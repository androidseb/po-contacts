import 'dart:convert';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class SyncInterfaceConfig {
  final String rootSyncFolderName;
  final String indexFileName;
  SyncInterfaceConfig(
    this.rootSyncFolderName,
    this.indexFileName,
  );
}

abstract class SyncInterface {
  static const String INDEX_FILE_KEY_NAME = 'name';
  static const String INDEX_FILE_KEY_FILE_ID = 'fileId';

  final SyncInterfaceConfig config;
  SyncModel _syncModel;

  RemoteFile _selectedCloudIndexFile;

  String _derivedEncryptionKey;

  SyncInterface(this.config, final SyncModel syncModel) {
    _syncModel = syncModel;
  }

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

  Future<void> setSelectedCloudIndexFile(final RemoteFile selectedCloudIndexFile) async {
    _selectedCloudIndexFile = selectedCloudIndexFile;
    //TODO write to _syncModel to persist the state between app runs
  }

  RemoteFile get selectedCloudIndexFile => _selectedCloudIndexFile;

  String get derivedEncryptionKey => _derivedEncryptionKey;

  FileEntity getLastSyncedFile() {
    //TODO
    return null;
  }

  Future<FileEntity> getLatestCloudFile() {
    return null;
  }
}
