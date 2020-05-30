import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';

class SyncInitialData<T> {
  final FileEntity candidateSyncFile;
  final List<T> localItems;
  final List<T> lastSyncedItems;
  final List<T> remoteItems;
  final String remoteFileETag;

  SyncInitialData(
    this.candidateSyncFile,
    this.localItems,
    this.lastSyncedItems,
    this.remoteItems,
    this.remoteFileETag,
  );
}

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

  Future<List<T>> _computeSyncResult(final SyncInitialData syncInitialData) async {
    //TODO
    return [];
  }

  Future<void> _finalizeSync(final List<T> syncResult, final String targetETag) async {
    //TODO
    return [];
  }

  Future<void> execute() async {
    _cancelationHandler.checkForCancelation();
    final SyncInitialData syncInitialData = await _initializeSync();
    _cancelationHandler.checkForCancelation();
    final List<T> syncResult = await _computeSyncResult(syncInitialData);
    _cancelationHandler.checkForCancelation();
    await _finalizeSync(syncResult, syncInitialData.remoteFileETag);
  }
}
