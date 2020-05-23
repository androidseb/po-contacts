import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:po_contacts_flutter/assets/constants/google_oauth_client_id.dart';
import 'package:po_contacts_flutter/controller/sync/data/remote_file.dart';
import 'package:po_contacts_flutter/controller/sync/sync_exception.dart';
import 'package:po_contacts_flutter/controller/sync/sync_interface.dart';
import 'package:po_contacts_flutter/controller/sync/sync_model.dart';

class GoogleDriveSyncInterface extends SyncInterface {
  static const String MULTIPART_REQUESTS_BOUNDARY_STRING = '5408960f22bc432e938025d3e6034c33';

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: POC_GOOGLE_OAUTH_CLIENT_ID,
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  Map<String, String> _authHeaders;

  GoogleDriveSyncInterface(final SyncModel syncModel) : super(syncModel);

  @override
  Future<bool> authenticateImplicitly() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signInSilently(suppressErrors: true);
    if (googleSignInAccount != null) {
      _authHeaders = await googleSignInAccount.authHeaders;
    }
    return googleSignInAccount != null;
  }

  @override
  Future<bool> authenticateExplicitly() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      _authHeaders = await googleSignInAccount.authHeaders;
    }
    return googleSignInAccount != null;
  }

  @override
  Future<RemoteFile> getRootFolder() async {
    final http.Response httpGetResponse = await http.get(
      'https://www.googleapis.com/drive/v2/about',
      headers: {
        'Authorization': _authHeaders['Authorization'],
        'Accept': 'application/json',
      },
    );
    if (httpGetResponse.statusCode == 200) {
      final serverResponse = jsonDecode(httpGetResponse.body);
      final String rootFolderId = serverResponse['rootFolderId'];
      return RemoteFile(RemoteFileType.FOLDER, rootFolderId, '');
    } else {
      throw SyncException(
        SyncExceptionType.server,
        message: 'GoogleDriveSyncInterface.getRootFolder failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<RemoteFile> createFolder(
    final RemoteFile parentFolder,
    final String folderName,
  ) async {
    final http.Response httpPostResponse = await http.post(
      'https://www.googleapis.com/drive/v3/files',
      headers: {
        'Authorization': _authHeaders['Authorization'],
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
      final serverResponse = jsonDecode(httpPostResponse.body);
      final String folderId = serverResponse['id'];
      return RemoteFile(RemoteFileType.FOLDER, folderId, folderName);
    } else {
      throw SyncException(
        SyncExceptionType.server,
        message: 'GoogleDriveSyncInterface.createFolder failed status code ${httpPostResponse.statusCode}',
      );
    }
  }

  String _createMultiPartRequestBodyString(
    final Map<String, dynamic> requestMetaData,
    final String fileContentString,
  ) {
    return '\r\n--$MULTIPART_REQUESTS_BOUNDARY_STRING\r\n' +
        'Content-Type: application/json; charset=UTF-8\r\n\r\n' +
        jsonEncode(requestMetaData) +
        '\r\n--$MULTIPART_REQUESTS_BOUNDARY_STRING\r\nContent-Type: text/plain\r\n\r\n' +
        fileContentString +
        '\r\n--$MULTIPART_REQUESTS_BOUNDARY_STRING--';
  }

  @override
  Future<RemoteFile> createNewTextFile(
    final RemoteFile parentFolder,
    final String fileName,
    final String fileTextContent,
  ) async {
    final Map<String, dynamic> requestMetaData = {
      'mimeType': 'application/json',
      'title': fileName,
      'parents': [
        {'id': parentFolder.fileId}
      ],
    };
    final String multiPartRequestBodyString = _createMultiPartRequestBodyString(requestMetaData, fileTextContent);
    final http.StreamedRequest fileStreamedRequest = http.StreamedRequest(
      'POST',
      Uri.parse('https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart'),
    );
    fileStreamedRequest.headers.addAll({
      'Authorization': _authHeaders['Authorization'],
      'Accept': 'application/json',
      'Content-Type': 'multipart/related; boundary=$MULTIPART_REQUESTS_BOUNDARY_STRING',
      'Content-Length': multiPartRequestBodyString.length.toString(),
    });
    fileStreamedRequest.sink.add(utf8.encode(multiPartRequestBodyString));
    fileStreamedRequest.sink.close();

    final http.StreamedResponse httpPostResponse = await fileStreamedRequest.send();

    if (httpPostResponse.statusCode == 200) {
      final serverResponse = jsonDecode(await httpPostResponse.stream.bytesToString());
      final String fileId = serverResponse['id'];
      return RemoteFile(RemoteFileType.FOLDER, fileId, fileName);
    } else {
      throw SyncException(
        SyncExceptionType.server,
        message: 'GoogleDriveSyncInterface.createNewTextFile failed status code ${httpPostResponse.statusCode}',
      );
    }
  }

  @override
  Future<RemoteFile> getFolder(
    final RemoteFile parentFolder,
    final String folderName,
  ) async {
    final String qParamValue =
        'mimeType ="application/vnd.google-apps.folder" and name = "$folderName"  and trashed = false and "${parentFolder.fileId}" in parents';
    final String url = 'https://www.googleapis.com/drive/v3/files?q=' + Uri.encodeComponent(qParamValue);
    final http.Response httpGetResponse = await http.get(
      url,
      headers: {
        'Authorization': _authHeaders['Authorization'],
        'Accept': 'application/json',
      },
    );
    if (httpGetResponse.statusCode == 404) {
      return null;
    } else if (httpGetResponse.statusCode == 200) {
      final serverResponse = jsonDecode(httpGetResponse.body);
      final List<dynamic> foundFiles = serverResponse['files'];
      if (foundFiles.isEmpty) {
        return null;
      } else {
        return RemoteFile(RemoteFileType.FOLDER, foundFiles[0]['id'], foundFiles[0]['name']);
      }
    } else {
      throw SyncException(
        SyncExceptionType.server,
        message: 'GoogleDriveSyncInterface.getFolder failed status code ${httpGetResponse.statusCode}',
      );
    }
  }

  @override
  Future<List<RemoteFile>> fetchIndexFilesList() async {
    // TODO: implement fetchIndexFilesList
    /*
    let qParam = 'mimeType ="application/vnd.google-apps.folder" and name = "'
            + AbstractCloudInterface.DEFAULT_CLOUD_FOLDER_NAME + '"  and trashed = false';
        let urlToFetch = 'https://www.googleapis.com/drive/v3/files/?q=' + encodeURIComponent(qParam);
        fetch(urlToFetch, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + _accessToken,
                'Accept': "application/json",
                'Content-Type': 'application/json',
            },
        })
        */
    return [];
  }
}
