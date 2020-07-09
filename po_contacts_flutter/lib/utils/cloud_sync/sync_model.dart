import 'dart:convert';

import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';
import 'package:po_contacts_flutter/utils/secure_storage/secure_storage.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncModelSerializer {
  static const String _SECURE_STORAGE_KEY_ENCRYPTION_KEY = 'secureStorageEncryptionKey';
  static const String _PREF_KEY_SYNC_MODEL_DATA = 'sync_model_data';
  static const String _JSON_KEY_SYNC_MODEL_INTERFACE_TYPE = 'interface_type';
  static const String _JSON_KEY_SYNC_MODEL_ACCOUNT_NAME = 'account_name';
  static const String _JSON_KEY_SYNC_MODEL_INDEX_FILE_ID = 'index_file_id';
  static const String _JSON_KEY_SYNC_MODEL_LAST_SYNC_TIME = 'last_sync_time';
  static const String _JSON_KEY_SYNC_MODEL_LAST_SYNC_DATA_FILE_ID = 'last_sync_data_file_id';
  static const String _JSON_KEY_SYNC_MODEL_HAS_LOCAL_CHANGES = 'has_local_changes';
  static const String _JSON_KEY_SYNC_MODEL_HAS_REMOTE_CHANGES = 'has_remote_changes';

  static final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();
  SyncModel _syncModel;

  Future<SyncModel> getSyncModel() async {
    if (_syncModel == null) {
      _syncModel = await _readSyncModel();
    }
    return _syncModel;
  }

  SyncModelData getSyncModelData() {
    return _syncModel;
  }

  Future<void> _saveDataToDisk() async {
    final String syncModelStringValue = jsonEncode(<String, dynamic>{
      _JSON_KEY_SYNC_MODEL_INTERFACE_TYPE:
          _syncModel._syncInterfaceType == null ? null : _syncModel._syncInterfaceType.index,
      _JSON_KEY_SYNC_MODEL_ACCOUNT_NAME: _syncModel._accountName,
      _JSON_KEY_SYNC_MODEL_INDEX_FILE_ID: _syncModel.cloudIndexFileId,
      _JSON_KEY_SYNC_MODEL_LAST_SYNC_TIME: _syncModel._lastSyncTimeEpochMillis,
      _JSON_KEY_SYNC_MODEL_LAST_SYNC_DATA_FILE_ID: _syncModel._lastSyncDataFileId,
      _JSON_KEY_SYNC_MODEL_HAS_LOCAL_CHANGES: _syncModel._hasLocalChanges,
      _JSON_KEY_SYNC_MODEL_HAS_REMOTE_CHANGES: _syncModel._hasRemoteChanges,
    });
    await (await _sharedPreferences).setString(_PREF_KEY_SYNC_MODEL_DATA, syncModelStringValue);
  }

  static SyncInterfaceType _intToSyncInterfaceType(final int syncInterfaceTypeInt) {
    for (final SyncInterfaceType t in SyncInterfaceType.values) {
      if (syncInterfaceTypeInt == t.index) {
        return t;
      }
    }
    return null;
  }

  Future<SyncModel> _readSyncModel() async {
    final String syncInterfaceStateValue = (await _sharedPreferences).getString(_PREF_KEY_SYNC_MODEL_DATA);
    Map<String, dynamic> syncInterfaceData;
    if (syncInterfaceStateValue == null) {
      syncInterfaceData = null;
    } else {
      try {
        syncInterfaceData = jsonDecode(syncInterfaceStateValue);
      } catch (_) {
        syncInterfaceData = null;
      }
    }

    final SyncInterfaceType syncInterfaceType =
        _intToSyncInterfaceType(Utils.getJSONMapInt(syncInterfaceData, _JSON_KEY_SYNC_MODEL_INTERFACE_TYPE));
    final String accountName = Utils.getJSONMapString(syncInterfaceData, _JSON_KEY_SYNC_MODEL_ACCOUNT_NAME);
    final String cloudIndexFileId = Utils.getJSONMapString(syncInterfaceData, _JSON_KEY_SYNC_MODEL_INDEX_FILE_ID);
    final int lastSyncTimeEpochMillis = Utils.getJSONMapInt(syncInterfaceData, _JSON_KEY_SYNC_MODEL_LAST_SYNC_TIME);
    final String lastSyncDataFileId =
        Utils.getJSONMapString(syncInterfaceData, _JSON_KEY_SYNC_MODEL_LAST_SYNC_DATA_FILE_ID);
    final bool hasLocalChanges = Utils.getJSONMapBool(syncInterfaceData, _JSON_KEY_SYNC_MODEL_HAS_LOCAL_CHANGES);
    final bool hasRemoteChanges = Utils.getJSONMapBool(syncInterfaceData, _JSON_KEY_SYNC_MODEL_HAS_REMOTE_CHANGES);
    return SyncModel(
      this,
      syncInterfaceType,
      accountName,
      cloudIndexFileId,
      lastSyncTimeEpochMillis,
      lastSyncDataFileId,
      hasLocalChanges,
      hasRemoteChanges,
    );
  }

  static Future<String> _getSecureStorageValueEncryptionKey() {
    return SecureStorage.instance.getValue(_SECURE_STORAGE_KEY_ENCRYPTION_KEY);
  }

  static Future<void> _setSecureStorageValueEncryptionKey(final String encryptionKey) {
    return SecureStorage.instance.setValue(_SECURE_STORAGE_KEY_ENCRYPTION_KEY, encryptionKey);
  }

  Future<void> clearData() async {
    _setSecureStorageValueEncryptionKey('');
    await (await _sharedPreferences).setString(_PREF_KEY_SYNC_MODEL_DATA, null);
    _syncModel = await _readSyncModel();
  }
}

class SyncModelData {
  SyncInterfaceType _syncInterfaceType;
  String _accountName;
  String _cloudIndexFileId;
  String _ramEncryptionKey;
  int _lastSyncTimeEpochMillis;
  String _lastSyncDataFileId;
  bool _hasLocalChanges;
  bool _hasRemoteChanges;

  SyncModelData(
    this._syncInterfaceType,
    this._accountName,
    this._cloudIndexFileId,
    this._lastSyncTimeEpochMillis,
    this._lastSyncDataFileId,
    this._hasLocalChanges,
    this._hasRemoteChanges,
  );

  SyncInterfaceType get syncInterfaceType => _syncInterfaceType;
  String get accountName => _accountName;
  String get cloudIndexFileId => _cloudIndexFileId;
  String get ramEncryptionKey => _ramEncryptionKey;
  int get lastSyncTimeEpochMillis => _lastSyncTimeEpochMillis;
  String get lastSyncDataFileId => _lastSyncDataFileId;
  bool get hasLocalChanges => _hasLocalChanges;
  bool get hasRemoteChanges => _hasRemoteChanges;
}

class SyncModel extends SyncModelData {
  final SyncModelSerializer _syncModelSerializer;

  SyncModel(
    this._syncModelSerializer,
    SyncInterfaceType syncInterfaceType,
    final String accountName,
    final String cloudIndexFileId,
    final int lastSyncTimeEpochMillis,
    final String lastSyncDataFileId,
    final bool hasLocalChanges,
    final bool hasRemoteChanges,
  ) : super(
          syncInterfaceType,
          accountName,
          cloudIndexFileId,
          lastSyncTimeEpochMillis,
          lastSyncDataFileId,
          hasLocalChanges,
          hasRemoteChanges,
        );

  Future<void> saveDataToDisk() async {
    return _syncModelSerializer._saveDataToDisk();
  }

  Future<void> setSyncInterfaceType(final SyncInterfaceType syncInterfaceType) async {
    _syncInterfaceType = syncInterfaceType;
    return saveDataToDisk();
  }

  Future<void> setCloudIndexFileId(final String cloudIndexFileId) async {
    _cloudIndexFileId = cloudIndexFileId;
    return saveDataToDisk();
  }

  Future<void> setAccountName(final String accountName) async {
    _accountName = accountName;
    return saveDataToDisk();
  }

  Future<void> setLastSyncTimeEpochMillis(final int lastSyncTimeEpochMillis) {
    _lastSyncTimeEpochMillis = lastSyncTimeEpochMillis;
    return saveDataToDisk();
  }

  Future<void> setLastSyncDataFileId(final String lastSyncDataFileId) {
    _lastSyncDataFileId = lastSyncDataFileId;
    return saveDataToDisk();
  }

  Future<String> getEncryptionKey() async {
    if (_ramEncryptionKey == null) {
      final String readKey = await SyncModelSerializer._getSecureStorageValueEncryptionKey();
      if (readKey != null && readKey.isNotEmpty) {
        _ramEncryptionKey = readKey;
      }
    }
    return _ramEncryptionKey;
  }

  Future<void> setEncryptionKey(final String encryptionKey, final bool rememberKey) async {
    _ramEncryptionKey = encryptionKey;
    if (rememberKey) {
      await SyncModelSerializer._setSecureStorageValueEncryptionKey(encryptionKey);
    }
  }

  Future<void> forgetEncryptionKey() async {
    _ramEncryptionKey = null;
    await SyncModelSerializer._setSecureStorageValueEncryptionKey('');
  }

  Future<void> setHasLocalChanges(final bool hasLocalChanges) async {
    _hasLocalChanges = hasLocalChanges;
    return saveDataToDisk();
  }

  Future<void> setHasRemoteChanges(final bool hasRemoteChanges) async {
    _hasRemoteChanges = hasRemoteChanges;
    return saveDataToDisk();
  }
}
