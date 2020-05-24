import 'dart:convert';

import 'package:po_contacts_flutter/controller/sync/data/remote_file.dart';
import 'package:po_contacts_flutter/controller/sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

abstract class SyncInterface {
  static const String PATH_SEPARATOR = '/';
  static const String ROOT_SYNC_FOLDER_NAME = 'pocontacts';
  static const String INDEX_FILE_NAME = 'po_contacts_index.json';

  static const String INDEX_FILE_KEY_NAME = 'name';
  static const String INDEX_FILE_KEY_FILE_ID = 'fileId';

  SyncModel _syncModel;
  SyncInterface(final SyncModel syncModel) {
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

  Future<RemoteFile> getOrCreateRootSyncFolder() async {
    final RemoteFile rootFolder = await getRootFolder();
    final RemoteFile existingRootSyncFolder = await getFolder(rootFolder, ROOT_SYNC_FOLDER_NAME);
    if (existingRootSyncFolder != null) {
      return existingRootSyncFolder;
    }
    return createFolder(rootFolder, ROOT_SYNC_FOLDER_NAME);
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
      INDEX_FILE_NAME,
      jsonEncode({
        INDEX_FILE_KEY_NAME: Utils.dateTimeToString(),
        INDEX_FILE_KEY_FILE_ID: null,
      }),
    );
  }

  Future<Map<String, dynamic>> getIndexFileContent(final String fileId) async {
    return jsonDecode(await getTextFileContent(fileId));
  }

  Future<void> setSelectedCloudIndexFile(final RemoteFile selectedCloudIndexFile) {
    //TODO
  }
}
