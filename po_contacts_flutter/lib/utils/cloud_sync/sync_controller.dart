import 'dart:async';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_items_handler.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/sync_interface_google_drive.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_prodedure.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/main_queue_yielder.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

enum SyncState {
  SYNC_IDLE,
  SYNC_IN_PROGRESS,
  SYNC_CANCELING,
}

//TODO add an option to start sync on app start
//TODO add an option to start sync on contact edit
//TODO initially encrypting with an empty dataset doesn't keep encryption
//TODO initial first sync without encryption clears the data (sync to cloud file -> disconnect account -> sync -> new file)
//TODO secure storage crashing on app start
//TODO non-adaptive icon devices have no app icon
abstract class SyncController<T> {
  /// Name for the candidate file to upload containing the next sync's result
  static const String _UPLOADED_SYNC_FILE_PRE_UPLOAD = 'uploaded_sync_file_pre_upload';

  /// Name for the candidate file after it has been successfully uploaded and marked as the new cloud version in the cloud index
  static const String _UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED = 'uploaded_sync_file_post_upload';

  /// Name for the last successfully finalized sync file after the sync procedure is finalized
  static const String _UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED = 'uploaded_sync_file_post_sync';

  /// Name for a downloaded cloud file's prefix (suffixed with the file id's MD5 checksum)
  static const String _DOWNLOADED_CLOUD_FILE_PREFIX = 'downloaded_';

  /// Suffix of a temporary cloud file (being downloaded and potentially not complete)
  static const String _TMP_CLOUD_FILE_SUFFIX = '.tmp';

  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.SYNC_IDLE);
  SyncState get syncState => _syncState.readOnly.currentValue;
  ReadOnlyStreamableValue<SyncState> get syncStateSV => _syncState.readOnly;
  SyncException _lastSyncError;
  SyncException get lastSyncError => _lastSyncError;
  final SyncModelSerializer _syncModelSerializer = SyncModelSerializer();
  Future<SyncModel> _getSyncModel() async {
    return _syncModelSerializer.getSyncModel();
  }

  SyncModelData get model => _syncModelSerializer.getSyncModelData();

  SyncProcedure<T> _currentSyncProcedure;

  SyncInterfaceConfig getSyncInterfaceConfig();

  SyncInterfaceUIController getSyncInterfaceUIController();

  SyncItemsHandler<T> getItemsHandler();

  Future<List<T>> getLocalItems();

  Future<bool> isFileEntityEncrypted(final FileEntity fileEntity);

  Future<List<T>> fileEntityToItemsList(
    final FileEntity fileEntity,
    final String encryptionKey,
  );

  Future<void> writeItemsListToFileEntity(
    final List<T> itemsList,
    final FileEntity fileEntity,
    final String encryptionKey,
  );

  Future<void> overwriteLocalItems(final List<T> itemsList);

  /// Select a cloud index file based on the name of that index file
  /// Returns 3 possible types of value:
  /// * the index of the user's choice
  /// * -1 if the user chose to create a new index
  /// * null if the user canceled
  Future<int> pickIndexFile(final List<String> cloudIndexFileNames);

  Future<FileEntity> fileEntityByName(final String fileName);

  SyncController() {
    _initSyncModelData();
  }

  void _initSyncModelData() async {
    await _getSyncModel();
    _syncState.notifyDataChanged();
  }

  Future<void> deleteFileWithName(final String fileName) async {
    final FileEntity fe = await fileEntityByName(fileName);
    if (await fe.exists()) {
      await fe.delete();
    }
  }

  Future<bool> fileWithNameExists(final String fileName) async {
    final FileEntity fe = await fileEntityByName(fileName);
    return fe != null && await fe.exists();
  }

  Future<void> moveFileByName(
    final String fileNameSource,
    final String fileNameDest,
  ) async {
    final FileEntity feSource = await fileEntityByName(fileNameSource);
    final FileEntity feDest = await fileEntityByName(fileNameDest);
    await feSource.move(feDest);
  }

  Future<void> overwriteFile(final String fileName, final Uint8List fileContent) async {
    final FileEntity fe = await fileEntityByName(fileName);
    if (!await fe.exists()) {
      await fe.create();
    }
    await fe.writeAsUint8List(fileContent);
  }

  Future<void> cancelSync() async {
    while (_syncState.currentValue == SyncState.SYNC_IN_PROGRESS) {
      if (_currentSyncProcedure == null) {
        await MainQueueYielder.check();
      } else {
        _currentSyncProcedure.cancel();
        _syncState.currentValue = SyncState.SYNC_CANCELING;
        _currentSyncProcedure = null;
      }
    }
  }

  void startSync() async {
    if (_syncState.currentValue == SyncState.SYNC_IN_PROGRESS) {
      return;
    }
    _syncState.currentValue = SyncState.SYNC_IN_PROGRESS;
    await _performSync(directUserAction: true);
    _syncState.currentValue = SyncState.SYNC_IDLE;
  }

  void logout() async {
    if (_syncState.currentValue == SyncState.SYNC_IN_PROGRESS || _syncState.currentValue == SyncState.SYNC_CANCELING) {
      return;
    }
    final SyncInterface syncInterface = await _readSyncInterfaceFromModel();
    await syncInterface.logout();
    await _syncModelSerializer.clearData();
    _syncState.notifyDataChanged();
  }

  Future<void> _performSync({bool directUserAction = false}) async {
    try {
      await _performSyncImpl(directUserAction: directUserAction);
      _updateLastSyncError(null);
    } on SyncException catch (syncException) {
      _updateLastSyncError(syncException);
    } catch (otherException) {
      _updateLastSyncError(SyncException(SyncExceptionType.OTHER, message: otherException.toString()));
    }
  }

  void _updateLastSyncError(final SyncException syncException) {
    if (syncException?.type == SyncExceptionType.CANCELED) {
      _lastSyncError = null;
      return;
    }
    _lastSyncError = syncException;
  }

  Future<SyncInterface> _initializeSyncInterface() async {
    final SyncModel syncModel = await _getSyncModel();
    final SyncInterface syncInterface = SyncInterfaceForGoogleDrive(
      getSyncInterfaceConfig(),
      getSyncInterfaceUIController(),
    );
    final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
    if (!couldAuthenticateExplicitly) {
      throw SyncException(SyncExceptionType.AUTHENTICATION);
    }
    final String accountName = await syncInterface.getAccountName();
    syncModel.setAccountName(accountName);
    final List<RemoteFile> cloudIndexFiles = await syncInterface.fetchIndexFilesList();
    RemoteFile selectedCloudIndexFile;
    if (cloudIndexFiles.isNotEmpty) {
      final List<String> indexFileNames = [];
      for (final RemoteFile cif in cloudIndexFiles) {
        final Map<String, dynamic> indexFileContent = await syncInterface.getIndexFileContent(cif.fileId);
        if (indexFileContent != null && indexFileContent[SyncInterface.INDEX_FILE_KEY_NAME] != null) {
          indexFileNames.add(indexFileContent[SyncInterface.INDEX_FILE_KEY_NAME]);
        } else {
          indexFileNames.add('???');
        }
      }
      final int indexFileChoiceIndex = await pickIndexFile(indexFileNames);
      if (indexFileChoiceIndex == null) {
        return null;
      } else if (indexFileChoiceIndex != -1) {
        selectedCloudIndexFile = cloudIndexFiles[indexFileChoiceIndex];
      }
    }
    if (selectedCloudIndexFile == null) {
      selectedCloudIndexFile = await syncInterface.createNewIndexFile();
      final String encryptionKey = await getSyncInterfaceUIController().promptUserForCreationSyncPassword();
      if (encryptionKey != null) {
        final bool rememberEncryptionKey = await getSyncInterfaceUIController().promptUserForSyncPasswordRemember();
        syncModel.setEncryptionKey(encryptionKey, rememberEncryptionKey);
      }
    }
    if (selectedCloudIndexFile == null) {
      return null;
    }
    await syncModel.setSyncInterfaceType(syncInterface.getSyncInterfaceType());
    await syncModel.setCloudIndexFileId(selectedCloudIndexFile.fileId);

    return syncInterface;
  }

  Future<SyncInterface> _readSyncInterfaceFromModel() async {
    final SyncModel syncModel = await _getSyncModel();
    if (syncModel.syncInterfaceType == SyncInterfaceType.GOOGLE_DRIVE) {
      return SyncInterfaceForGoogleDrive(
        getSyncInterfaceConfig(),
        getSyncInterfaceUIController(),
      );
    }
    return null;
  }

  Future<SyncInterface> _getAuthenticatedSyncInterface({bool directUserAction = false}) async {
    SyncInterface syncInterface = await _readSyncInterfaceFromModel();
    if (syncInterface == null) {
      syncInterface = await _initializeSyncInterface();
      if (syncInterface == null) {
        throw SyncException(SyncExceptionType.CANCELED);
      }
    } else {
      final bool couldAuthenticateImplicitly = await syncInterface.authenticateImplicitly();
      if (!couldAuthenticateImplicitly) {
        if (directUserAction) {
          final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
          if (!couldAuthenticateExplicitly) {
            throw SyncException(SyncExceptionType.AUTHENTICATION);
          }
        } else {
          throw SyncException(SyncExceptionType.AUTHENTICATION);
        }
      }
    }
    return syncInterface;
  }

  Future<void> _performSyncImpl({bool directUserAction = false}) async {
    final SyncModel syncModel = await _getSyncModel();
    final SyncInterface syncInterface = await _getAuthenticatedSyncInterface(directUserAction: directUserAction);
    _currentSyncProcedure = SyncProcedure(this, syncModel, syncInterface);
    try {
      await _currentSyncProcedure.execute();
      await (await _getSyncModel()).setLastSyncTimeEpochMillis(Utils.currentTimeMillis());
    } on SyncException catch (syncException) {
      if (syncException.type == SyncExceptionType.FILE_PARSING_ERROR) {
        syncModel.forgetEncryptionKey();
      }
      throw syncException;
    }
    _currentSyncProcedure = null;
  }

  Future<FileEntity> prepareCandidateUploadFileForSync() async {
    await deleteFileWithName(_UPLOADED_SYNC_FILE_PRE_UPLOAD);
    if (await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED)) {
      await deleteFileWithName(_UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED);
      await moveFileByName(
        _UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED,
        _UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED,
      );
    }
    return fileEntityByName(_UPLOADED_SYNC_FILE_PRE_UPLOAD);
  }

  Future<void> markCandidateUploadFileAsSyncSucceeded() async {
    if (!await fileWithNameExists(_UPLOADED_SYNC_FILE_PRE_UPLOAD)) {
      return;
    }
    if (await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED)) {
      await deleteFileWithName(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED);
    }
    await moveFileByName(
      _UPLOADED_SYNC_FILE_PRE_UPLOAD,
      _UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED,
    );
  }

  Future<void> markSyncSucceededFileAsSyncFinalized() async {
    if (!await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED)) {
      return;
    }
    if (await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED)) {
      await deleteFileWithName(_UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED);
    }
    await moveFileByName(
      _UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED,
      _UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED,
    );
  }

  Future<FileEntity> getLastSyncedFile() async {
    if (await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED)) {
      return fileEntityByName(_UPLOADED_SYNC_FILE_POST_SYNC_SUCCEEDED);
    }
    if (await fileWithNameExists(_UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED)) {
      return fileEntityByName(_UPLOADED_SYNC_FILE_POST_SYNC_FINALIZED);
    }
    return null;
  }

  Future<FileEntity> getLatestCloudFile(final SyncInterface syncInterface) async {
    final SyncModel syncModel = await _getSyncModel();
    final String cloudIndexFileId = syncModel.cloudIndexFileId;
    if (cloudIndexFileId == null) {
      return null;
    }
    final Map<String, dynamic> cloudIndexFileContent = await syncInterface.getIndexFileContent(cloudIndexFileId);
    final dynamic latestCloudFileId = cloudIndexFileContent[SyncInterface.INDEX_FILE_KEY_FILE_ID];
    if (!(latestCloudFileId is String)) {
      return null;
    }
    final String downloadedFileName = _DOWNLOADED_CLOUD_FILE_PREFIX + Utils.stringToMD5(latestCloudFileId as String);
    if (await fileWithNameExists(downloadedFileName)) {
      return fileEntityByName(downloadedFileName);
    }
    //TODO cleanup older downloaded files
    final String tmpDownloadedFileName = _DOWNLOADED_CLOUD_FILE_PREFIX + _TMP_CLOUD_FILE_SUFFIX;
    final Uint8List latestCloudFileContent = await syncInterface.downloadCloudFile(latestCloudFileId as String);
    await overwriteFile(tmpDownloadedFileName, latestCloudFileContent);
    await moveFileByName(tmpDownloadedFileName, downloadedFileName);
    return fileEntityByName(downloadedFileName);
  }

  Future<void> requestEncryptionKeyIfNeeded(
    final SyncInterface syncInterface,
    final FileEntity latestCloudFile,
  ) async {
    final SyncModel syncModel = await _getSyncModel();
    if (latestCloudFile == null || !await isFileEntityEncrypted(latestCloudFile)) {
      return;
    }
    String encryptionKey = await syncModel.getEncryptionKey();
    if (encryptionKey != null) {
      return;
    }
    encryptionKey = await getSyncInterfaceUIController().promptUserForResumeSyncPassword();
    if (encryptionKey == null) {
      throw SyncException(SyncExceptionType.CANCELED);
    }
    final bool rememberKey = await getSyncInterfaceUIController().promptUserForSyncPasswordRemember();
    await syncModel.setEncryptionKey(encryptionKey, rememberKey);
  }

  void recordLocalDataChanged() {
    if (_currentSyncProcedure != null) {
      _currentSyncProcedure.recordLocalDataChanged();
    }
  }
}
