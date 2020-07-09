import 'dart:async';

import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel {
  static const String _SETTING_ID_USE_DRAGGABLE_SCROLLBAR = 'use_draggable_scrollbar';
  static const String _SETTING_ID_EMAIL_ACTION = 'email_action';
  static const String _SETTING_ID_CALL_ACTION = 'call_action';
  static const String _SETTING_ID_USE_DARK_DISPLAY = 'dark_display';
  static const String _SETTING_ID_SYNC_ON_APP_START = 'sync_on_app_start';
  static const String _SETTING_ID_SYNC_ON_DATA_EDIT = 'sync_on_data_edit';

  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();
  final StreamableValue<AppSettings> _appSettings = StreamableValue(AppSettings());
  AppSettings get appSettings => _appSettings.readOnly.currentValue;
  ReadOnlyStreamableValue<AppSettings> get appSettingsSV => _appSettings.readOnly;

  SettingsModel() {
    _updateSettingsFromStorage();
  }

  Future<void> waitForSettingsLoaded(){
    return _updateSettingsFromStorage();
  }

  Future<bool> _readDisplayDraggableScrollbarValue() async {
    final bool displayDraggableScrollbar = (await _sharedPreferences).getBool(_SETTING_ID_USE_DRAGGABLE_SCROLLBAR);
    if (displayDraggableScrollbar != null) {
      return displayDraggableScrollbar;
    }
    return AppSettings.getDefaultDisplayScrollbarOption();
  }

  Future<int> _readEmailActionId() async {
    final int emailActionId = (await _sharedPreferences).getInt(_SETTING_ID_EMAIL_ACTION);
    if (emailActionId != null) {
      return emailActionId;
    }
    return AppSettings.getDefaultEmailActionId();
  }

  Future<int> _readCallActionId() async {
    final int callActionId = (await _sharedPreferences).getInt(_SETTING_ID_CALL_ACTION);
    if (callActionId != null) {
      return callActionId;
    }
    return AppSettings.getDefaultCallActionId();
  }

  Future<bool> _readUseDarkDisplay() async {
    final bool useDarkDisplay = (await _sharedPreferences).getBool(_SETTING_ID_USE_DARK_DISPLAY);
    if (useDarkDisplay != null) {
      return useDarkDisplay;
    }
    return AppSettings.getDefaultUseDarkDisplayOption();
  }

  Future<bool> _readSyncOnAppStart() async {
    final bool syncOnAppStart = (await _sharedPreferences).getBool(_SETTING_ID_SYNC_ON_APP_START);
    if (syncOnAppStart != null) {
      return syncOnAppStart;
    }
    return true;
  }

  Future<bool> _readSyncOnDataEdit() async {
    final bool syncOnDataEdit = (await _sharedPreferences).getBool(_SETTING_ID_SYNC_ON_DATA_EDIT);
    if (syncOnDataEdit != null) {
      return syncOnDataEdit;
    }
    return false;
  }

  Future<void> _updateSettingsFromStorage() async {
    _appSettings.currentValue = AppSettings(
      displayDraggableScrollbar: await _readDisplayDraggableScrollbarValue(),
      emailActionId: await _readEmailActionId(),
      callActionId: await _readCallActionId(),
      useDarkDisplay: await _readUseDarkDisplay(),
      syncOnAppStart: await _readSyncOnAppStart(),
      syncOnDataEdit: await _readSyncOnDataEdit(),
    );
  }

  void setUseDraggableScrollbar(final bool useDraggableScrollbar) async {
    (await _sharedPreferences).setBool(_SETTING_ID_USE_DRAGGABLE_SCROLLBAR, useDraggableScrollbar);
    _updateSettingsFromStorage();
  }

  void setEmailActionId(final int emailActionId) async {
    (await _sharedPreferences).setInt(_SETTING_ID_EMAIL_ACTION, emailActionId);
    _updateSettingsFromStorage();
  }

  void setCallActionId(final int callActionId) async {
    (await _sharedPreferences).setInt(_SETTING_ID_CALL_ACTION, callActionId);
    _updateSettingsFromStorage();
  }

  void setUseDarkDisplay(final bool useDarkDisplay) async {
    (await _sharedPreferences).setBool(_SETTING_ID_USE_DARK_DISPLAY, useDarkDisplay);
    _updateSettingsFromStorage();
  }

  void setSyncOnAppStart(final bool syncOnAppStart) async {
    (await _sharedPreferences).setBool(_SETTING_ID_SYNC_ON_APP_START, syncOnAppStart);
    _updateSettingsFromStorage();
  }

  void setSyncOnDataEdit(final bool syncOnDataEdit) async {
    (await _sharedPreferences).setBool(_SETTING_ID_SYNC_ON_DATA_EDIT, syncOnDataEdit);
    _updateSettingsFromStorage();
  }
}
