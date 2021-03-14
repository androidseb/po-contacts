import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

enum SyncInterfaceType {
  GOOGLE_DRIVE,
}

class SyncInterfaceConfig {
  final String? rootSyncFolderName;
  final String? indexFileName;
  final String? versionFileNameSuffix;
  final String? clientId;
  final String? clientIdDesktop;
  final String? clientSecret;
  SyncInterfaceConfig({
    this.rootSyncFolderName,
    this.indexFileName,
    this.versionFileNameSuffix,
    this.clientId,
    this.clientIdDesktop,
    this.clientSecret,
  });
}

abstract class SyncInterfaceUIController {
  BuildContext? getUIBuildContext();

  /// Select a cloud index file based on the name of that index file
  /// Returns 3 possible types of value:
  /// * the index of the user's choice
  /// * -1 if the user chose to create a new index
  /// * null if the user canceled
  Future<int?> pickIndexFile(final List<String?> cloudIndexFileNames);

  /// Select a history data file based on the name of that history data file.
  /// Returns 2 possible types of value:
  /// * the index of the user's choice
  /// * null if the user canceled
  Future<int?> pickHistoryDataFile(final List<String?> cloudDataFileNames);

  void copyTextToClipBoard(final String? text);

  Future<String> promptUserForCreationSyncPassword();

  Future<String?> promptUserForResumeSyncPassword();

  Future<bool> promptUserForSyncPasswordRemember();

  final String googleAuthCancelButtonText;
  final String googleAuthDialogTitleText;
  final String googleAuthDialogMessageText;
  final String googleAuthDialogCopyCodeButtonText;
  final String googleAuthDialogOpenBrowserButtonText;
  final String continueGoogleAuthDialogTitleText;
  final String continueGoogleAuthDialogMessageText;
  final String continueGoogleAuthDialogProceedButtonText;
  final String continueGoogleAuthDialogRestartButtonText;

  SyncInterfaceUIController({
    this.googleAuthCancelButtonText = 'Cancel',
    this.googleAuthDialogTitleText = 'Google Authentication',
    this.googleAuthDialogMessageText =
        'In order to authenticate this app with Google, you will need the special code below. Click the "Copy code" button, then click the "Open browser" button and paste the code there. This should start the authentication process with Google. Once you\'re done, come back to the app to finish authenticating.',
    this.googleAuthDialogCopyCodeButtonText = 'Copy code',
    this.googleAuthDialogOpenBrowserButtonText = 'Open browser',
    this.continueGoogleAuthDialogTitleText = 'Finalize Google Authentication',
    this.continueGoogleAuthDialogMessageText =
        'Once you have authenticated to Google in your browser, click the "Proceed" button. If something went wrong and you need to restart the process, simply click the "Retry" button.',
    this.continueGoogleAuthDialogRestartButtonText = 'Retry',
    this.continueGoogleAuthDialogProceedButtonText = 'Proceed',
  });
}

abstract class SyncInterface {
  static const String INDEX_FILE_KEY_NAME = 'name';
  static const String INDEX_FILE_KEY_FILE_ID = 'fileId';

  final SyncInterfaceConfig config;
  final SyncInterfaceUIController uiController;

  SyncInterface(this.config, this.uiController);

  SyncInterfaceType getSyncInterfaceType();
  Future<bool> authenticateImplicitly();
  Future<bool> authenticateExplicitly();
  Future<void> logout();
  Future<String?> getAccountName();
  Future<RemoteFile> getRootFolder();
  Future<RemoteFile?> getFolder(
    final RemoteFile parentFolder,
    final String? folderName,
  );
  Future<String?> getParentFolderId(
    final String? fileId,
  );
  Future<RemoteFile> createFolder(
    final RemoteFile parentFolder,
    final String? folderName,
  );
  Future<RemoteFile> createNewFile(
    final String? parentFolderId,
    final String? fileName,
    final Uint8List fileContent,
  );
  Future<RemoteFile> overwriteFile(
    final String? fileId,
    final Uint8List fileContent, {
    String? targetETag,
  });
  Future<List<RemoteFile>> fetchIndexFilesList();
  Future<List<RemoteFile>?> fetchFolderFilesList(final String cloudIndexFileId);
  Future<String?> getFileETag(final String? fileId);
  Future<Uint8List?> downloadCloudFile(final String? fileId);

  Future<String> getTextFileContent(final String? fileId) async {
    return utf8.decode(await (downloadCloudFile(fileId) as Future<List<int>>));
  }

  Future<RemoteFile> getOrCreateRootSyncFolder() async {
    final RemoteFile rootFolder = await getRootFolder();
    final RemoteFile? existingRootSyncFolder = await getFolder(rootFolder, config.rootSyncFolderName);
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
    return createNewFile(
      newIndexFolder.fileId,
      config.indexFileName,
      utf8.encode(jsonEncode({
        INDEX_FILE_KEY_NAME: Utils.dateTimeToString(),
        INDEX_FILE_KEY_FILE_ID: null,
      })) as Uint8List,
    );
  }

  Future<RemoteFile> updateIndexFile(
    final String? indexFileId,
    final String? refDataFileId,
    final String? targetETag,
  ) async {
    return overwriteFile(
      indexFileId,
      utf8.encode(jsonEncode({
        INDEX_FILE_KEY_NAME: Utils.dateTimeToString(),
        INDEX_FILE_KEY_FILE_ID: refDataFileId,
      })) as Uint8List,
      targetETag: targetETag,
    );
  }

  Future<Map<String, dynamic>?> getIndexFileContent(final String? fileId) async {
    return jsonDecode(await getTextFileContent(fileId));
  }

  Future<List<RemoteFile>?> fetchHistoryAsDataFilesList(final String cloudIndexFileId) async {
    final List<RemoteFile>? rawFilesList = await fetchFolderFilesList(cloudIndexFileId);
    if (rawFilesList == null) {
      return null;
    }
    final List<RemoteFile> filteredFilesList = [];
    for (final RemoteFile f in rawFilesList) {
      if (f.fileName!.endsWith(config.versionFileNameSuffix!)) {
        filteredFilesList.add(f);
      }
    }
    return filteredFilesList;
  }
}
