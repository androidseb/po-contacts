import 'package:po_contacts_flutter/controller/sync/sync_exception.dart';
import 'package:po_contacts_flutter/controller/sync/sync_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncModel {
  static const String _SYNC_CONFIG = 'sync_config';

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  Future<String> _readSyncConfigValue() async {
    final String syncConfigValue = (await _sharedPreferences).getString(_SYNC_CONFIG);
    return syncConfigValue;
  }

  Future<SyncInterface> getCurrentSyncInterface() async {
    return null;
  }

  void updateLastSyncError(SyncException syncException) {}
}
