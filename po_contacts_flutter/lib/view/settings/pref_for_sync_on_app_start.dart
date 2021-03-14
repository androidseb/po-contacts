import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/settings/bool_setting_entry.dart';

class PrefForSyncOnAppStart extends BoolSettingEntry {
  @override
  String getLabelText() {
    return I18n.getString(I18n.string.start_sync_on_app_start);
  }

  @override
  bool readCurrentValue() {
    return MainController.get()!.model.settings.appSettings!.syncOnAppStart;
  }

  @override
  void writeCurrentValue(final bool? v) {
    MainController.get()!.model.settings.setSyncOnAppStart(v!);
  }
}
