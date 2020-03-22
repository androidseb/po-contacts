import 'dart:async';

import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel {
  static const String _SETTING_ID_USE_DRAGGABLE_SCROLLBAR = 'use_draggable_scrollbar';
  static const String _SETTING_ID_EMAIL_ACTION = 'email_action';
  static const String _SETTING_ID_CALL_ACTION = 'call_action';

  AppSettings _appSettings = AppSettings();
  AppSettings get appSettings => _appSettings;
  final Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  SettingsModel() {
    _updateSettingsFromStorage();
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

  Future<void> _updateSettingsFromStorage() async {
    _appSettings = AppSettings(
      displayDraggableScrollbar: await _readDisplayDraggableScrollbarValue(),
      emailActionId: await _readEmailActionId(),
      callActionId: await _readCallActionId(),
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
}
