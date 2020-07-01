import 'package:flutter/material.dart';

import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';

class AppSettings {
  static const _THUNDERBIRD_APP_NAME = 'Thunderbird';
  static const _LINPHONE_APP_NAME = 'Linphone';
  static const int EMAIL_ACTION_SYSTEM_DEFAULT = 0;
  static const int CALL_ACTION_SYSTEM_DEFAULT = 0;
  static const int EMAIL_ACTION_THUNDERBIRD = 1;
  static const int CALL_ACTION_LINPHONE = 1;

  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _EMAIL_ACTION_CHOICES_LINUX = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_with_system,
      ),
      entryId: EMAIL_ACTION_SYSTEM_DEFAULT,
    ),
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_application_x,
        _THUNDERBIRD_APP_NAME,
      ),
      entryId: EMAIL_ACTION_THUNDERBIRD,
    ),
  ];
  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _EMAIL_ACTION_CHOICES_MACOS = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_with_system,
      ),
      entryId: EMAIL_ACTION_SYSTEM_DEFAULT,
    ),
  ];
  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _EMAIL_ACTION_CHOICES_WINDOWS = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_with_system,
      ),
      entryId: EMAIL_ACTION_SYSTEM_DEFAULT,
    ),
  ];

  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _CALL_ACTION_CHOICES_LINUX = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_application_x,
        _LINPHONE_APP_NAME,
      ),
      entryId: CALL_ACTION_LINPHONE,
    ),
  ];
  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _CALL_ACTION_CHOICES_MACOS = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_with_system,
      ),
      entryId: EMAIL_ACTION_SYSTEM_DEFAULT,
    ),
  ];
  //ignore: non_constant_identifier_names
  static final List<MultiSelectionChoice> _CALL_ACTION_CHOICES_WINDOWS = [
    MultiSelectionChoice(
      I18n.getString(
        I18n.string.open_with_system,
      ),
      entryId: EMAIL_ACTION_SYSTEM_DEFAULT,
    ),
  ];

  static bool getDefaultDisplayScrollbarOption() {
    return MainController.get().psController.basicInfoManager.isDesktop;
  }

  static int getDefaultEmailActionId() {
    return EMAIL_ACTION_SYSTEM_DEFAULT;
  }

  static int getDefaultCallActionId() {
    if (MainController.get().psController.basicInfoManager.isLinux) {
      return CALL_ACTION_LINPHONE;
    } else {
      return CALL_ACTION_SYSTEM_DEFAULT;
    }
  }

  static Future<bool> getDefaultUseDarkDisplayOption() async {
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  static List<MultiSelectionChoice> getEmailActionChoices() {
    if (MainController.get().psController.basicInfoManager.isLinux) {
      return _EMAIL_ACTION_CHOICES_LINUX;
    } else if (MainController.get().psController.basicInfoManager.isMacOS) {
      return _EMAIL_ACTION_CHOICES_MACOS;
    } else if (MainController.get().psController.basicInfoManager.isWindows) {
      return _EMAIL_ACTION_CHOICES_WINDOWS;
    } else {
      return [];
    }
  }

  static List<MultiSelectionChoice> getCallActionChoices() {
    if (MainController.get().psController.basicInfoManager.isLinux) {
      return _CALL_ACTION_CHOICES_LINUX;
    } else if (MainController.get().psController.basicInfoManager.isMacOS) {
      return _CALL_ACTION_CHOICES_MACOS;
    } else if (MainController.get().psController.basicInfoManager.isWindows) {
      return _CALL_ACTION_CHOICES_WINDOWS;
    } else {
      return [];
    }
  }

  final bool displayDraggableScrollbar;
  final int emailActionId;
  final int callActionId;
  final bool useDarkDisplay;

  AppSettings({
    this.displayDraggableScrollbar: false,
    this.emailActionId: 0,
    this.callActionId: 0,
    this.useDarkDisplay: false,
  });
}
