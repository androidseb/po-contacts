import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';

class SyncInterfaceForGoogleDrive extends SyncInterface {
  static const String _MULTIPART_REQUESTS_BOUNDARY_STRING = '5408960f22bc432e938025d3e6034c33';

  String _accessToken;

  SyncInterfaceForGoogleDrive(final SyncInterfaceConfig config, final SyncInterfaceUIController uiController)
      : super(config, uiController);

  SyncInterfaceType getSyncInterfaceType() {
    return SyncInterfaceType.GOOGLE_DRIVE;
  }

  @override
  Future<bool> authenticateImplicitly() async {
    final String resultingAccessToken = await GoogleOAuth.instance.obtainAccessToken(this, false);
    if (resultingAccessToken != null) {
      _accessToken = resultingAccessToken;
    }
    return resultingAccessToken != null;
  }

  @override
  Future<bool> authenticateExplicitly() async {
    final String resultingAccessToken = await GoogleOAuth.instance.obtainAccessToken(this, true);
    if (resultingAccessToken != null) {
      _accessToken = resultingAccessToken;
    }
    return resultingAccessToken != null;
  }

  @override
  Future<void> logout() async {
    return GoogleOAuth.instance.logout(this);
  }

  Future<Map<String, dynamic>> _getAboutData() async {
    final http.Response httpGetResponse = await http.get(
      'https://www.googleapis.com/drive/v2/about',
      headers: {
        'Authorization': _accessToken,
        'Accept': 'application/json',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      return jsonDecode(httpGetResponse.body);
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface._getAboutData failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<String> getAccountName() async {
    final Map<String, dynamic> aboutData = await _getAboutData();
    return aboutData['user']['emailAddress'];
  }

  @override
  Future<RemoteFile> getRootFolder() async {
    final Map<String, dynamic> aboutData = await _getAboutData();
    final String rootFolderId = aboutData['rootFolderId'];
    return RemoteFile(RemoteFileType.FOLDER, rootFolderId, '', '');
  }

  RemoteFile _googleDriveFileToRemoteFile(final dynamic googleDriveFile) {
    RemoteFileType remoteFileType;
    if (googleDriveFile['mimeType'] == 'application/vnd.google-apps.folder') {
      remoteFileType = RemoteFileType.FOLDER;
    } else {
      remoteFileType = RemoteFileType.FILE;
    }
    return RemoteFile(remoteFileType, googleDriveFile['id'], googleDriveFile['name'], googleDriveFile['etag']);
  }

  @override
  Future<RemoteFile> createFolder(
    final RemoteFile parentFolder,
    final String folderName,
  ) async {
    final http.Response httpPostResponse = await http.post(
      'https://www.googleapis.com/drive/v3/files',
      headers: {
        'Authorization': _accessToken,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mimeType': 'application/vnd.google-apps.folder',
        'name': folderName,
        'parents': [parentFolder.fileId],
      }),
    );
    if (httpPostResponse.statusCode == 200) {
      final Map<String, dynamic> serverResponse = jsonDecode(httpPostResponse.body);
      return _googleDriveFileToRemoteFile(serverResponse);
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface.createFolder failed status code ${httpPostResponse.statusCode}',
      );
    }
  }

  String _createMultiPartRequestBodyString(
    final Map<String, dynamic> requestMetaData,
    final Uint8List fileContent,
  ) {
    return '\r\n--$_MULTIPART_REQUESTS_BOUNDARY_STRING\r\n' +
        'Content-Type: application/json; charset=UTF-8\r\n\r\n' +
        jsonEncode(requestMetaData) +
        '\r\n--$_MULTIPART_REQUESTS_BOUNDARY_STRING\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: base64\r\n\r\n' +
        base64.encode(fileContent) +
        '\r\n--$_MULTIPART_REQUESTS_BOUNDARY_STRING--';
  }

  Future<RemoteFile> _uploadFile(
    Uint8List fileContent, {
    String fileId,
    String targetETag,
    String parentFolderId,
    String fileName,
  }) async {
    final Map<String, dynamic> requestMetaData = <String, dynamic>{
      'mimeType': 'application/json',
    };
    if (fileId == null) {
      requestMetaData['title'] = fileName;
      requestMetaData['parents'] = [
        {'id': parentFolderId}
      ];
    }
    final String multiPartRequestBodyString = _createMultiPartRequestBodyString(requestMetaData, fileContent);
    String requestUrl;
    if (fileId == null) {
      requestUrl = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
    } else {
      requestUrl = 'https://www.googleapis.com/upload/drive/v2/files/$fileId?uploadType=multipart';
    }
    final http.StreamedRequest fileStreamedRequest = http.StreamedRequest(
      fileId == null ? 'POST' : 'PUT',
      Uri.parse(requestUrl),
    );
    fileStreamedRequest.headers.addAll({
      'Authorization': _accessToken,
      'Accept': 'application/json',
      'Content-Type': 'multipart/related; boundary=$_MULTIPART_REQUESTS_BOUNDARY_STRING',
      'Content-Length': multiPartRequestBodyString.length.toString(),
    });
    if (targetETag != null) {
      fileStreamedRequest.headers.addAll({
        'If-Match': targetETag,
      });
    }
    fileStreamedRequest.sink.add(utf8.encode(multiPartRequestBodyString));
    fileStreamedRequest.sink.close();

    final http.StreamedResponse httpPostResponse = await fileStreamedRequest.send();

    if (httpPostResponse.statusCode == 200) {
      final Map<String, dynamic> serverResponse = jsonDecode(await httpPostResponse.stream.bytesToString());
      return _googleDriveFileToRemoteFile(serverResponse);
    } else if (httpPostResponse.statusCode == 412) {
      throw SyncException(SyncExceptionType.CONCURRENCY);
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface._uploadFile failed status code ${httpPostResponse.statusCode}',
      );
    }
  }

  @override
  Future<RemoteFile> createNewFile(
    final String parentFolderId,
    final String fileName,
    final Uint8List fileContent,
  ) async {
    return _uploadFile(
      fileContent,
      parentFolderId: parentFolderId,
      fileName: fileName,
    );
  }

  @override
  Future<RemoteFile> overwriteFile(
    final String fileId,
    final Uint8List fileContent, {
    String targetETag,
  }) {
    return _uploadFile(
      fileContent,
      fileId: fileId,
      targetETag: targetETag,
    );
  }

  @override
  Future<RemoteFile> getFolder(
    final RemoteFile parentFolder,
    final String folderName,
  ) async {
    final String qParamValue = Uri.encodeComponent(
      'mimeType ="application/vnd.google-apps.folder" and name = "$folderName"  and trashed = false and "${parentFolder.fileId}" in parents',
    );
    final String url = 'https://www.googleapis.com/drive/v3/files?q=$qParamValue';
    final http.Response httpGetResponse = await http.get(
      url,
      headers: {
        'Authorization': _accessToken,
        'Accept': 'application/json',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      final Map<String, dynamic> serverResponse = jsonDecode(httpGetResponse.body);
      final List<dynamic> foundFiles = serverResponse['files'];
      if (foundFiles.isEmpty) {
        return null;
      } else {
        return _googleDriveFileToRemoteFile(foundFiles[0]);
      }
    } else if (httpGetResponse.statusCode == 404) {
      return null;
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface.getFolder failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<String> getParentFolderId(
    final String fileId,
  ) async {
    final dynamic fileMetaData = await _getFileMetadata(fileId);
    if (!(fileMetaData is Map)) {
      return null;
    }
    final dynamic parents = fileMetaData['parents'];
    if (!(parents is List)) {
      return null;
    }
    return parents[0]['id'];
  }

  Future<List<RemoteFile>> _fetchFilesList(final String rawQParamString) async {
    final String qParamValue = Uri.encodeComponent(rawQParamString);
    final String url = 'https://www.googleapis.com/drive/v3/files?q=$qParamValue';
    final http.Response httpGetResponse = await http.get(
      url,
      headers: {
        'Authorization': _accessToken,
        'Accept': 'application/json',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      final Map<String, dynamic> serverResponse = jsonDecode(httpGetResponse.body);
      final List<dynamic> foundFiles = serverResponse['files'];
      final List<RemoteFile> res = [];
      for (final dynamic foundFile in foundFiles) {
        res.add(RemoteFile(RemoteFileType.FOLDER, foundFile['id'], foundFile['name'], foundFile['etag']));
      }
      return res;
    } else if (httpGetResponse.statusCode == 404) {
      return [];
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface.getFolder failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<List<RemoteFile>> fetchIndexFilesList() async {
    return _fetchFilesList('name = "${config.indexFileName}" and trashed = false');
  }

  @override
  Future<List<RemoteFile>> fetchFolderFilesList(final String cloudIndexFileId) async {
    final String parentFolderId = await getParentFolderId(cloudIndexFileId);
    if (parentFolderId == null) {
      return null;
    }
    return _fetchFilesList('"$parentFolderId" in parents and trashed = false');
  }

  Future<dynamic> _getFileMetadata(final String fileId) async {
    final String url = 'https://www.googleapis.com/drive/v2/files/$fileId';
    final http.Response httpGetResponse = await http.get(
      url,
      headers: {
        'Authorization': _accessToken,
        'Accept': 'text/plain',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      return jsonDecode(httpGetResponse.body);
    } else if (httpGetResponse.statusCode == 404) {
      return null;
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface._getFileMetadata failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<String> getFileETag(final String fileId) async {
    final dynamic fileMetaData = await _getFileMetadata(fileId);
    if (!(fileMetaData is Map)) {
      return null;
    }
    return fileMetaData['etag'];
  }

  @override
  Future<Uint8List> downloadCloudFile(final String fileId) async {
    final String url = 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
    final http.Response httpGetResponse = await http.get(
      url,
      headers: {
        'Authorization': _accessToken,
        'Accept': 'text/plain',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      return httpGetResponse.bodyBytes;
    } else if (httpGetResponse.statusCode == 404) {
      return null;
    } else {
      throw SyncException(
        SyncExceptionType.SERVER,
        message: 'GoogleDriveSyncInterface.getFolder failed status code ${httpGetResponse.statusCode}',
      );
    }
  }
}
