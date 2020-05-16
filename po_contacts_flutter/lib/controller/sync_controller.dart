import 'dart:async';

import 'package:po_contacts_flutter/utils/streamable_value.dart';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

class SyncController {
  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.IDLE);
  ReadOnlyStreamableValue<SyncState> get syncState => _syncState.readOnly;

  void onClickSyncButton() async {
    if (_syncState.currentValue == SyncState.SYNCING) {
      return;
    }
    _syncState.currentValue = SyncState.SYNCING;
    final bool syncSuccessful = await performSync();
    if (syncSuccessful) {
      _syncState.currentValue = SyncState.IDLE;
    } else {
      _syncState.currentValue = SyncState.LAST_SYNC_FAILED;
    }
  }

  Future<bool> performSync() async {
    //TODO
    await Future.delayed(const Duration(milliseconds: 5000));
    return false;
  }
}
