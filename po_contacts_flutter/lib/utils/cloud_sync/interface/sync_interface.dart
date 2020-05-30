import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface_google_drive.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

enum SyncInterfaceType {
  GOOGLE_DRIVE,
}

class SyncInterfaceConfig {
  final String rootSyncFolderName;
  final String indexFileName;
  SyncInterfaceConfig(
    this.rootSyncFolderName,
    this.indexFileName,
  );
}

abstract class SyncInterface {
  static const String _JSON_KEY_SYNC_INTERFACE_TYPE = 'type';
  static const String _JSON_KEY_SYNC_INTERFACE_INDEX_FILE_ID = 'index_file_id';

  static const String INDEX_FILE_KEY_NAME = 'name';
  static const String INDEX_FILE_KEY_FILE_ID = 'fileId';

  static String syncInterfaceToString(final SyncInterface syncInterface) {
    final String indexFileId = syncInterface._cloudIndexFileId;
    if (indexFileId == null) {
      return null;
    }
    return jsonEncode({
      _JSON_KEY_SYNC_INTERFACE_TYPE: syncInterface.getSyncInterfaceType().index,
      _JSON_KEY_SYNC_INTERFACE_INDEX_FILE_ID: indexFileId,
    });
  }

  static SyncInterface stringToSyncInterface(
    final SyncInterfaceConfig config,
    final SyncModel syncModel,
    final String syncInterfaceAsString,
  ) {
    if (syncInterfaceAsString == null || syncInterfaceAsString == '') {
      return null;
    }
    final Map<String, dynamic> syncInterfaceData = jsonDecode(syncInterfaceAsString);
    SyncInterface res;
    if (syncInterfaceData[_JSON_KEY_SYNC_INTERFACE_TYPE] == SyncInterfaceType.GOOGLE_DRIVE.index) {
      res = SyncInterfaceForGoogleDrive(config, syncModel);
    }
    if (res != null) {
      res._cloudIndexFileId = syncInterfaceData[_JSON_KEY_SYNC_INTERFACE_INDEX_FILE_ID];
    }
    return res;
  }

  final SyncInterfaceConfig config;
  SyncModel _syncModel;

  String _cloudIndexFileId;

  String _encryptionKey;

  SyncInterface(this.config, final SyncModel syncModel) {
    _syncModel = syncModel;
  }

  SyncInterfaceType getSyncInterfaceType();
  Future<bool> authenticateImplicitly();
  Future<bool> authenticateExplicitly();
  Future<RemoteFile> getRootFolder();
  Future<RemoteFile> getFolder(
    final RemoteFile parentFolder,
    final String folderName,
  );
  Future<RemoteFile> createFolder(
    final RemoteFile parentFolder,
    final String folderName,
  );
  Future<RemoteFile> createNewTextFile(
    final RemoteFile parentFolder,
    final String fileName,
    final String fileTextContent,
  );
  Future<List<RemoteFile>> fetchIndexFilesList();
  Future<String> getTextFileContent(final String fileId);
  Future<String> getFileETag(final String fileId);
  Future<Uint8List> downloadCloudFile(final String fileId);

  Future<RemoteFile> getOrCreateRootSyncFolder() async {
    final RemoteFile rootFolder = await getRootFolder();
    final RemoteFile existingRootSyncFolder = await getFolder(rootFolder, config.rootSyncFolderName);
    if (existingRootSyncFolder != null) {
      return existingRootSyncFolder;
    }
    return createFolder(rootFolder, config.rootSyncFolderName);
  }

  Future<RemoteFile> createNewIndexFolder() async {
    final RemoteFile rootSyncFolder = await getOrCreateRootSyncFolder();
    final RemoteFile newIndexFolder = await createFolder(
      rootSyncFolder,
      Utils.dateTimeToString(),
    );
    return newIndexFolder;
  }

  Future<RemoteFile> createNewIndexFile() async {
    final RemoteFile newIndexFolder = await createNewIndexFolder();
    return createNewTextFile(
      newIndexFolder,
      config.indexFileName,
      jsonEncode({
        INDEX_FILE_KEY_NAME: Utils.dateTimeToString(),
        INDEX_FILE_KEY_FILE_ID: null,
      }),
    );
  }

  Future<Map<String, dynamic>> getIndexFileContent(final String fileId) async {
    return jsonDecode(await getTextFileContent(fileId));
  }

  Future<void> setCloudIndexFileId(final String cloudIndexFileId) async {
    _cloudIndexFileId = cloudIndexFileId;
    await saveToModel();
  }

  Future<void> saveToModel() async {
    await _syncModel.writeSyncInterfaceValue(syncInterfaceToString(this));
  }

  String get cloudIndexFileId => _cloudIndexFileId;

  String get encryptionKey => _encryptionKey;
}
