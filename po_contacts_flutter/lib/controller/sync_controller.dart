import 'dart:async';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

class SyncController {
  SyncState _syncState = SyncState.IDLE;
  final StreamController<SyncState> _syncStateSC = StreamController();
  Stream<SyncState> _syncStateStream;

  SyncState get syncState => _syncState;

  Stream<SyncState> get syncStateStream {
    if (_syncStateStream == null) {
      _syncStateStream = _syncStateSC.stream.asBroadcastStream();
    }
    return _syncStateStream;
  }

  void onClickSyncButton() async {
    if (_syncState == SyncState.SYNCING) {
      return;
    }
    _syncState = SyncState.SYNCING;
    _syncStateSC.add(_syncState);
    final bool syncSuccessful = await performSync();
    if (syncSuccessful) {
      _syncState = SyncState.IDLE;
    } else {
      _syncState = SyncState.LAST_SYNC_FAILED;
    }
    _syncStateSC.add(_syncState);
  }

  Future<bool> performSync() async {
    //TODO
    await Future.delayed(const Duration(milliseconds: 5000));
    return false;
  }
}
