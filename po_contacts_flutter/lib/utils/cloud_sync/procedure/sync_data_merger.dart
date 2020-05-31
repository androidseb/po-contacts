import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_result_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_prodedure.dart';

class SyncDataMerger<T> {
  final SyncCancelationHandler _cancelationHandler;
  final SyncInitialData<T> _syncInitialData;

  SyncDataMerger(this._syncInitialData, this._cancelationHandler);

  /// Compute the list of created items between two versions of a list of items (past vs present)
  Map<String, T> _createIdToItemMap(final List<T> itemsList) {}

  /// Compute the list of created items between two versions sets of items (past vs present)
  List<T> _computeCreatedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {}

  /// Compute the list of modified items between two versions sets of items (past vs present)
  List<T> _computeModifiedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {}

  /// Compute the list of modified items between two versions sets of items (past vs present)
  List<T> _computeDeletedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {}

  Future<SyncResultData> computeSyncResult() async {
    final Map<String, T> lastSyncedItems = _createIdToItemMap(_syncInitialData.lastSyncedItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> localItems = _createIdToItemMap(_syncInitialData.localItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> remoteItems = _createIdToItemMap(_syncInitialData.remoteItems);
    _cancelationHandler.checkForCancelation();
    final List<T> locallyCreatedItems = _computeCreatedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final List<T> locallyModifiedItems = _computeModifiedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final List<T> locallyDeletedItems = _computeDeletedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final List<T> remoteCreatedItems = _computeCreatedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();
    final List<T> remoteModifiedItems = _computeModifiedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();
    final List<T> remoteDeletedItems = _computeDeletedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();

    //TODO implement this whole logic properly, for now the sync is dumb and will simply upload the local data to the remote
    return SyncResultData<T>(
      initialData: _syncInitialData,
      syncResultData: _syncInitialData.localItems,
      hasLocalChanges: false,
      hasRemoteChanges: true,
    );
  }
}
