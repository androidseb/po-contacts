import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/settings/bool_setting_entry.dart';

class PrefForDisplayObsoleteAddressFields extends BoolSettingEntry {
  @override
  String getLabelText() {
    return I18n.getString(I18n.string.display_obsolete_address_fields);
  }

  @override
  bool readCurrentValue() {
    return MainController.get().model.settings.appSettings.displayObsoleteAddressFields;
  }

  @override
  void writeCurrentValue(final bool v) {
    MainController.get().model.settings.setDisplayObsoleteAddressFields(v);
  }
}
