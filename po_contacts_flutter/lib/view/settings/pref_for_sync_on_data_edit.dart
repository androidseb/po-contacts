import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/settings/bool_setting_entry.dart';

class PrefForSyncOnDataEdit extends BoolSettingEntry {
  @override
  String getLabelText() {
    return I18n.getString(I18n.string.start_sync_on_data_edit);
  }

  @override
  bool readCurrentValue() {
    return MainController.get().model.settings.appSettings.syncOnDataEdit;
  }

  @override
  void writeCurrentValue(final bool v) {
    MainController.get().model.settings.setSyncOnDataEdit(v);
  }
}
