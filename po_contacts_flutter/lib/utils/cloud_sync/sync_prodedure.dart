import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/remote_file.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_interface.dart';

class SyncInitialData<T> {
  final List<T> localItems;
  final List<T> lastSyncedItems;
  final List<T> remoteItems;
  final String remoteFileETag;

  SyncInitialData(
    this.localItems,
    this.lastSyncedItems,
    this.remoteItems,
    this.remoteFileETag,
  );
}

class SyncProcedure<T> {
  final SyncController syncController;
  final SyncInterface syncInterface;
  bool _canceled = false;

  SyncProcedure(this.syncController, this.syncInterface);

  void cancel() {
    _canceled = false;
  }

  Future<SyncInitialData> _initializeSync() async {
    final List<T> localItems = await syncController.getLocalItems();
    final FileEntity lastSyncedFile = syncInterface.getLastSyncedFile();
    final List<T> lastSyncedItems = await syncController.fileEntityToItemsList(
      lastSyncedFile,
      syncInterface.encryptionKey,
    );
    final FileEntity latestCloudFile = await syncInterface.getLatestCloudFile();
    final List<T> remoteItems = await syncController.fileEntityToItemsList(
      latestCloudFile,
      syncInterface.encryptionKey,
    );
    final RemoteFile currentIndexFile = syncInterface.selectedCloudIndexFile;
    final String fileETag = await syncInterface.getFileETag(currentIndexFile.fileId);
    return SyncInitialData(
      localItems,
      lastSyncedItems,
      remoteItems,
      fileETag,
    );
  }

  Future<List<T>> _computeSyncResult(final SyncInitialData syncInitialData) async {
    //TODO
  }

  Future<void> _finalizeSync(final List<T> syncResult, final String targetETag) async {
    //TODO
  }

  Future<void> execute() async {
    final SyncInitialData syncInitialData = await _initializeSync();
    final List<T> syncResult = await _computeSyncResult(syncInitialData);
    await _finalizeSync(syncResult, syncInitialData.remoteFileETag);
  }
}
