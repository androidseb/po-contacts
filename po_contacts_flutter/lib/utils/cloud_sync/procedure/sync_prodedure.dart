import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_result_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_data_merger.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';

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
  final SyncController _syncController;
  final SyncInterface _syncInterface;
  SyncCancelationHandler _cancelationHandler;

  SyncProcedure(this._syncController, this._syncInterface) {
    _cancelationHandler = SyncCancelationHandler(this);
  }

  void cancel() {
    _cancelationHandler.cancel();
  }

  Future<SyncInitialData> _initializeSync() async {
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
    final FileEntity latestCloudFile = await _syncController.getLatestCloudFile();
    _cancelationHandler.checkForCancelation();
    final List<T> remoteItems = await _syncController.fileEntityToItemsList(
      latestCloudFile,
      _syncInterface.encryptionKey,
    );
    _cancelationHandler.checkForCancelation();
    final String fileETag = await _syncInterface.getFileETag(_syncInterface.cloudIndexFileId);
    return SyncInitialData(
      candidateSyncFile,
      localItems,
      lastSyncedItems,
      remoteItems,
      fileETag,
    );
  }

  Future<SyncResultData> _computeSyncResult(final SyncInitialData syncInitialData) async {
    return await SyncDataMerger(
      syncInitialData,
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
      //TODO upload the file
    }
    if (syncResult.hasLocalChanges) {
      //TODO change the local data with the updated sync data
    }
  }

  Future<void> execute() async {
    _cancelationHandler.checkForCancelation();
    final SyncInitialData syncInitialData = await _initializeSync();
    _cancelationHandler.checkForCancelation();
    final SyncResultData syncResult = await _computeSyncResult(syncInitialData);
    _cancelationHandler.checkForCancelation();
    await _finalizeSync(syncResult);
  }
}
