import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncModel {
  static const String _PREF_KEY_SYNC_INTERFACE = 'sync_interface_state';

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  Future<String> _readSyncInterfaceValue() async {
    final String syncInterfaceStateValue = (await _sharedPreferences).getString(_PREF_KEY_SYNC_INTERFACE);
    return syncInterfaceStateValue;
  }

  Future<void> writeSyncInterfaceValue(final String syncInterfaceValue) async {
    await (await _sharedPreferences).setString(_PREF_KEY_SYNC_INTERFACE, syncInterfaceValue);
  }

  Future<SyncInterface> getCurrentSyncInterface(final SyncInterfaceConfig config) async {
    final String syncInterfaceValue = await _readSyncInterfaceValue();
    return SyncInterface.stringToSyncInterface(config, this, syncInterfaceValue);
  }

  void updateLastSyncError(final SyncException syncException) {
    //TODO
  }
}
