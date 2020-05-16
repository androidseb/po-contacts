import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:po_contacts_flutter/view/settings/multi_selection_entry.dart';

class PrefForEmailAction extends MultiSelectionEntry {
  PrefForEmailAction() : super(AppSettings.getEmailActionChoices());

  @override
  String getLabelText() {
    return I18n.getString(I18n.string.email_action);
  }

  @override
  int readCurrentValue() {
    return MainController.get().model.settings.appSettings.currentValue.emailActionId;
  }

  @override
  writeCurrentValue(final int v) {
    MainController.get().model.settings.setEmailActionId(v);
  }
}
