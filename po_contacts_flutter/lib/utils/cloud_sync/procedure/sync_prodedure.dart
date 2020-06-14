import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_result_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_data_merger.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class SyncCancelationHandler {
  final SyncProcedure syncProcedure;
  bool _canceled = false;

  void cancel() {
    _canceled = false;
  }

  SyncCancelationHandler(this.syncProcedure);

  void checkForCancelation() {
    if (_canceled) {
      throw SyncException(SyncExceptionType.CANCELED);
    }
  }
}

class SyncProcedure<T> {
  final SyncController<T> _syncController;
  final SyncInterface _syncInterface;
  SyncCancelationHandler _cancelationHandler;
  bool _localDataChanged = false;

  SyncProcedure(this._syncController, this._syncInterface) {
    _cancelationHandler = SyncCancelationHandler(this);
  }

  void cancel() {
    _cancelationHandler.cancel();
  }

  void recordLocalDataChanged() {
    _localDataChanged = true;
  }

  Future<SyncInitialData<T>> _initializeSync() async {
    final FileEntity candidateSyncFile = await _syncController.prepareCandidateUploadFileForSync();
    _cancelationHandler.checkForCancelation();
    final List<T> localItems = await _syncController.getLocalItems();
    _cancelationHandler.checkForCancelation();
    final FileEntity lastSyncedFile = await _syncController.getLastSyncedFile();
    _cancelationHandler.checkForCancelation();
    final List<T> lastSyncedItems = await _syncController.fileEntityToItemsList(
      lastSyncedFile,
      _syncInterface.encryptionKey,
    );
    _cancelationHandler.checkForCancelation();
    final FileEntity latestCloudFile = await _syncController.getLatestCloudFile(_syncInterface);
    _cancelationHandler.checkForCancelation();
    final List<T> remoteItems = await _syncController.fileEntityToItemsList(
      latestCloudFile,
      _syncInterface.encryptionKey,
    );
    _cancelationHandler.checkForCancelation();
    final String fileETag = await _syncInterface.getFileETag(_syncInterface.cloudIndexFileId);
    return SyncInitialData<T>(
      candidateSyncFile,
      localItems,
      lastSyncedItems,
      remoteItems,
      fileETag,
    );
  }

  Future<SyncResultData<T>> _computeSyncResult(final SyncInitialData<T> syncInitialData) async {
    return await SyncDataMerger<T>(
      syncInitialData,
      _syncController.getItemInfoProvider(),
      _cancelationHandler,
    ).computeSyncResult();
  }

  Future<void> _finalizeSync(final SyncResultData<T> syncResult) async {
    final FileEntity fileToUpload = syncResult.initialData.candidateSyncFile;
    await _syncController.writeItemsListToFileEntity(
      syncResult.syncResultData,
      fileToUpload,
      _syncInterface.encryptionKey,
    );
    if (syncResult.hasRemoteChanges) {
      final String cloudIndexFileId = _syncInterface.cloudIndexFileId;
      final String cloudFolderId = await _syncInterface.getParentFolderId(cloudIndexFileId);
      final Uint8List fileToUploadContent = base64.decode(await fileToUpload.readAsBase64String());
      final RemoteFile newCloudFile = await _syncInterface.createNewFile(
        cloudFolderId,
        Utils.dateTimeToString(),
        fileToUploadContent,
      );
      await _syncInterface.updateIndexFile(
        cloudIndexFileId,
        newCloudFile.fileId,
        syncResult.initialData.remoteFileETag,
      );
    }
    await _syncController.markCandidateUploadFileAsSyncSucceeded();
    if (syncResult.hasLocalChanges && !_localDataChanged) {
      await _syncController.overwriteLocalItems(syncResult.syncResultData);
    }
    await _syncController.markSyncSucceededFileAsSyncFinalized();
  }

  Future<void> execute() async {
    _cancelationHandler.checkForCancelation();
    final SyncInitialData<T> syncInitialData = await _initializeSync();
    _cancelationHandler.checkForCancelation();
    final SyncResultData<T> syncResult = await _computeSyncResult(syncInitialData);
    _cancelationHandler.checkForCancelation();
    await _finalizeSync(syncResult);
  }
}
