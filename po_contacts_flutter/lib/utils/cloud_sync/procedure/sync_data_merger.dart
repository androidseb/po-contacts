import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_items_handler.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_result_data.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/procedure/sync_prodedure.dart';

class SyncDataMerger<T> {
  final SyncInitialData<T> _syncInitialData;
  final SyncItemsHandler<T> _itemsHandler;
  final SyncCancelationHandler _cancelationHandler;

  SyncDataMerger(
    this._syncInitialData,
    this._itemsHandler,
    this._cancelationHandler,
  );

  /// Compute the list of created items between two versions of a list of items (past vs present)
  Map<String, T> _createIdToItemMap(final List<T> itemsList) {
    final Map<String, T> res = {};
    for (final T item in itemsList) {
      res[_itemsHandler.getItemId(item)] = item;
    }
    return res;
  }

  /// Compute the list of created items between two versions sets of items (past vs present)
  Map<String, T> _computeCreatedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {
    final Map<String, T> res = {};
    for (final String itemId in presentItems.keys) {
      if (!pastItems.containsKey(itemId)) {
        final item = presentItems[itemId];
        if (item != null) {
          res[itemId] = item;
        }
      }
    }
    return res;
  }

  /// Compute the list of modified items between two versions sets of items (past vs present)
  Map<String, T> _computeModifiedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {
    final Map<String, T> res = {};
    for (final String itemId in pastItems.keys) {
      if (presentItems.containsKey(itemId)) {
        final T? pastItem = pastItems[itemId];
        final T? presentItem = presentItems[itemId];
        if (!_itemsHandler.itemsEqualExceptId(pastItem, presentItem)) {
          if (presentItem != null) {
            res[itemId] = presentItem;
          }
        }
      }
    }
    return res;
  }

  /// Compute the list of modified items between two versions sets of items (past vs present)
  Map<String, T> _computeDeletedItems(final Map<String, T> pastItems, final Map<String, T> presentItems) {
    final Map<String, T> res = {};
    for (final String itemId in pastItems.keys) {
      if (!presentItems.containsKey(itemId)) {
        final item = pastItems[itemId];
        if (item != null) {
          res[itemId] = item;
        }
      }
    }
    return res;
  }

  void _resolveMergeConflicts(
    final Map<String, T> localCreatedItems,
    final Map<String, T> localModifiedItems,
    final Map<String, T> localDeletedItems,
    final Map<String, T> remoteCreatedItems,
    final Map<String, T> remoteModifiedItems,
    final Map<String, T> remoteDeletedItems,
  ) {
    // Handling conflicts for any remotely modified item
    for (final String rmItemId in remoteModifiedItems.keys) {
      // Handling conflict of "remotely modified item" vs "locally modified item"
      {
        // Checking for a locally modified item matching the remotely modified item id
        final T? lmItem = localModifiedItems[rmItemId];
        // If the item has been modified both remotely and locally, we will keep both versions.
        // This is done by considering the local modification as a newly created item instead of a modified one.
        if (lmItem != null) {
          // Removing the "locally modified" record for that item
          localModifiedItems.remove(rmItemId);
          // Cloning the item with a new unique ID to avoid any clash with other items
          final T clonedItem = _itemsHandler.cloneItemWithNewId(lmItem);
          // Obtaining the newly cloned item ID
          final String clonedItemId = _itemsHandler.getItemId(clonedItem);
          // Adding the newly cloned item to the list of "locally created" records
          localCreatedItems[clonedItemId] = clonedItem;
        }
      }
      // Handling conflict of "remotely modified item" vs "locally deleted item"
      {
        // Checking for a locally deleted item matching the remotely modified item id
        final T? ldItem = localDeletedItems[rmItemId];
        // If the item has been modified remotely and deleted locally, we will cancel its deletion.
        // This is done by ignoring the local deletion.
        if (ldItem != null) {
          localDeletedItems.remove(rmItemId);
        }
      }
    }

    // Handling conflicts for any remotely deleted item
    // Extracting the remotely deleted item ids from the remoteDeletedItems map into a dedicated variable since the
    // iteration might remove items from the map causing concurrent modification errors
    final Set<String> remoteDeletedItemIds = remoteDeletedItems.keys.toSet();
    for (final String rdItemId in remoteDeletedItemIds) {
      // Handling conflict of "remotely deleted item" vs "locally modified item"
      {
        // Checking for a locally modified item matching the remotely deleted item id
        final T? lmItem = localModifiedItems[rdItemId];
        // If the item has been deleted remotely and modified locally, we will cancel its deletion.
        // This is done by ignoring the remote deletion.
        if (lmItem != null) {
          remoteDeletedItems.remove(rdItemId);
        }
      }
      // Handling conflict of "remotely deleted item" vs "locally deleted item"
      {
        // Checking for a locally deleted item matching the remotely deleted item id
        final T? ldItem = localDeletedItems[rdItemId];
        // If the item has been deleted both remotely locally, we will delete it.
        // However we will avoid registering two deletions.
        // This is done by ignoring the local deletion, since the remote deletion will be enough.
        if (ldItem != null) {
          localDeletedItems.remove(rdItemId);
        }
      }
    }
  }

  /// Adds or overwrite map entries from mapToAdd to destMap
  /// Returns true if at least one item was added, false otherwise
  bool _appendMapEntries(final Map<String, T> destMap, final Map<String, T> mapToAdd) {
    bool mapChanged = false;
    for (final String itemId in mapToAdd.keys) {
      final item = mapToAdd[itemId];
      if (item != null) {
        destMap[itemId] = item;
        mapChanged = true;
      }
    }
    return mapChanged;
  }

  /// Removes map entries from mapToDelete to destMap
  /// Returns true if at least one item was removed, false otherwise
  bool _removeMapEntries(final Map<String, T> destMap, final Map<String, T> mapToDelete) {
    bool mapChanged = false;
    for (final String itemId in mapToDelete.keys) {
      if (destMap.remove(itemId) != null) {
        mapChanged = true;
      }
    }
    return mapChanged;
  }

  /// Computes the result of the sync between local and remote, based on the sync initial data.
  ///
  /// The result of the last sync will be the starting point of the "result" data.
  /// From there, applying the combination of local and remote modifications will produce the end result.
  ///
  /// If there are remotely modified or deleted items, there could be a conflict if we have either modified or
  /// deleted the same items locally as well. To avoid loss of data, in case of conflict on the same item:
  /// - if both sides deleted -> simply delete
  /// - if both sides modified -> keep both copies (will result in 2 modified copies of the same item)
  /// - if deleted on one side and modified on the other -> keep the modified item
  Future<SyncResultData<T>> computeSyncResult() async {
    // Initializing an ID <=> item map for the last synced items
    final Map<String, T> lastSyncedItems = _createIdToItemMap(_syncInitialData.lastSyncedItems);
    _cancelationHandler.checkForCancelation();

    // Initializing an ID <=> item map for the local items
    final Map<String, T> localItems = _createIdToItemMap(_syncInitialData.localItems);
    _cancelationHandler.checkForCancelation();

    // Initializing an ID <=> item map for the remote items
    final Map<String, T> remoteItems = _createIdToItemMap(_syncInitialData.remoteItems);
    _cancelationHandler.checkForCancelation();

    // Based on the last synced items, computing what changes have occurred locally and remotely
    final Map<String, T> localCreatedItems = _computeCreatedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> localModifiedItems = _computeModifiedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> localDeletedItems = _computeDeletedItems(lastSyncedItems, localItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> remoteCreatedItems = _computeCreatedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> remoteModifiedItems = _computeModifiedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();
    final Map<String, T> remoteDeletedItems = _computeDeletedItems(lastSyncedItems, remoteItems);
    _cancelationHandler.checkForCancelation();

    // Initializing the syncResult variable based on the result of the last sync
    final Map<String, T> syncResult = Map<String, T>.from(lastSyncedItems);

    // Initializing a variable to track whether some changes are to be applied locally
    bool changesToLocal = false;

    // Initializing a variable to track whether some changes are to be applied remotely
    bool changesToRemote = false;

    // Adjusting target changes to resolve merge conflicts and avoid loss of data
    _resolveMergeConflicts(
      localCreatedItems,
      localModifiedItems,
      localDeletedItems,
      remoteCreatedItems,
      remoteModifiedItems,
      remoteDeletedItems,
    );
    _cancelationHandler.checkForCancelation();

    // Applying created cloud items to the result
    changesToLocal = _appendMapEntries(syncResult, remoteCreatedItems) || changesToLocal;
    _cancelationHandler.checkForCancelation();

    // Applying modified cloud items to the result
    changesToLocal = _appendMapEntries(syncResult, remoteModifiedItems) || changesToLocal;
    _cancelationHandler.checkForCancelation();

    // Applying deleted cloud items to the result
    changesToLocal = _removeMapEntries(syncResult, remoteDeletedItems) || changesToLocal;
    _cancelationHandler.checkForCancelation();

    // Applying created local items to the result
    changesToRemote = _appendMapEntries(syncResult, localCreatedItems) || changesToRemote;
    _cancelationHandler.checkForCancelation();

    // Applying modified local items to the result
    changesToRemote = _appendMapEntries(syncResult, localModifiedItems) || changesToRemote;
    _cancelationHandler.checkForCancelation();

    // Applying deleted local items to the result
    changesToRemote = _removeMapEntries(syncResult, localDeletedItems) || changesToRemote;
    _cancelationHandler.checkForCancelation();

    return SyncResultData<T>(
      initialData: _syncInitialData,
      syncResultData: List<T>.from(syncResult.values),
      hasLocalChanges: changesToLocal,
      hasRemoteChanges: changesToRemote,
    );
  }
}
