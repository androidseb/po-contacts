import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';

class AppSettings {
  static const int EMAIL_ACTION_THUNDERBIRD = 0;
  static const int CALL_ACTION_LINPHONE = 0;

  static List<MultiSelectionChoice> _EMAIL_ACTION_CHOICES_LINUX = [
    MultiSelectionChoice(EMAIL_ACTION_THUNDERBIRD, I18n.getString(I18n.string.open_application_x, 'Thunderbird')),
  ];

  static List<MultiSelectionChoice> _CALL_ACTION_CHOICES_LINUX = [
    MultiSelectionChoice(CALL_ACTION_LINPHONE, I18n.getString(I18n.string.open_application_x, 'Linphone')),
  ];

  static bool getDefaultDisplayScrollbarOption() {
    //TODO if statement based on OS
    return true;
  }

  static int getDefaultEmailActionId() {
    //TODO if statement based on OS
    return EMAIL_ACTION_THUNDERBIRD;
  }

  static List<MultiSelectionChoice> getEmailActionChoices() {
    //TODO if statement based on OS
    return _EMAIL_ACTION_CHOICES_LINUX;
  }

  static int getDefaultCallActionId() {
    return CALL_ACTION_LINPHONE;
  }

  static List<MultiSelectionChoice> getCallActionChoices() {
    //TODO if statement based on OS
    return _CALL_ACTION_CHOICES_LINUX;
  }

  final bool displayDraggableScrollbar;
  final int emailActionId;
  final int callActionId;

  AppSettings({this.displayDraggableScrollbar: false, this.emailActionId: 0, this.callActionId: 0});
}
