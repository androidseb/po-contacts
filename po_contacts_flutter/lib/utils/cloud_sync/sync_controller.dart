import 'dart:async';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_data_id_provider.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface_google_drive.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_prodedure.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_model.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

//TODO make it work for iOS
//TODO make it work for web
//TODO UX around encryption
//TODO add an option to start sync on app start
//TODO add an option to start sync on contact edit
//TODO add an option to view the last sync error
//TODO add an option to cancel the sync
//TODO add an option to view history and restore
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

  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.IDLE);
  SyncState get syncState => _syncState.readOnly.currentValue;
  ReadOnlyStreamableValue<SyncState> get syncStateSV => _syncState.readOnly;
  final SyncModel _syncModel = SyncModel();
  SyncProcedure<T> _currentSyncProcedure;

  SyncInterfaceConfig getSyncInterfaceConfig();

  SyncDataInfoProvider<T> getItemInfoProvider();

  Future<List<T>> getLocalItems();

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
    while (_syncState.currentValue == SyncState.SYNCING) {
      if (_currentSyncProcedure == null) {
        await Utils.yieldMainQueue();
      } else {
        _currentSyncProcedure.cancel();
        _currentSyncProcedure = null;
      }
    }
  }

  void onClickSyncButton() async {
    if (_syncState.currentValue == SyncState.SYNCING) {
      return;
    }
    _syncState.currentValue = SyncState.SYNCING;
    final bool syncSuccessful = await performSync(directUserAction: true);
    if (syncSuccessful) {
      _syncState.currentValue = SyncState.IDLE;
    } else {
      _syncState.currentValue = SyncState.LAST_SYNC_FAILED;
    }
  }

  Future<bool> performSync({bool directUserAction = false}) async {
    try {
      await _performSyncImpl(directUserAction: directUserAction);
      _syncModel.updateLastSyncError(null);
      return true;
    } on SyncException catch (syncException) {
      _syncModel.updateLastSyncError(syncException);
    } catch (otherException) {
      _syncModel.updateLastSyncError(SyncException(SyncExceptionType.OTHER, message: otherException.toString()));
    }
    return false;
  }

  Future<SyncInterface> _initializeSyncInterface() async {
    final SyncInterface syncInterface = SyncInterfaceForGoogleDrive(getSyncInterfaceConfig(), _syncModel);
    final bool couldAuthenticateExplicitly = await syncInterface.authenticateExplicitly();
    if (!couldAuthenticateExplicitly) {
      throw SyncException(SyncExceptionType.AUTHENTICATION);
    }
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
    }
    if (selectedCloudIndexFile == null) {
      return null;
    }
    await syncInterface.setCloudIndexFileId(selectedCloudIndexFile.fileId);
    return syncInterface;
  }

  Future<SyncInterface> _getAuthenticatedSyncInterface({bool directUserAction = false}) async {
    SyncInterface syncInterface = await _syncModel.getCurrentSyncInterface(getSyncInterfaceConfig());
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
    final SyncInterface syncInterface = await _getAuthenticatedSyncInterface(directUserAction: directUserAction);
    _currentSyncProcedure = SyncProcedure(this, syncInterface);
    await _currentSyncProcedure.execute();
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
    final String cloudIndexFileId = syncInterface.cloudIndexFileId;
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

  void recordLocalDataChanged() {
    if (_currentSyncProcedure != null) {
      _currentSyncProcedure.recordLocalDataChanged();
    }
  }
}
