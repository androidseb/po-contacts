import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/settings/bool_setting_entry.dart';

class PrefForDarkDisplay extends BoolSettingEntry {
  @override
  String getLabelText() {
    return I18n.getString(I18n.string.use_dark_display);
  }

  @override
  bool readCurrentValue() {
    return MainController.get().model.settings.appSettings.currentValue.useDarkDisplay;
  }

  @override
  writeCurrentValue(final bool v) {
    MainController.get().model.settings.setUseDarkDisplay(v);
  }
}
