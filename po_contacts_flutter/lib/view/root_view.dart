import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/home/home_page.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamedWidget<AppSettings>(MainController.get().model.settings.appSettingsSV,
        (final BuildContext context, final AppSettings appSettings) {
      return MaterialApp(
        title: I18n.getString(I18n.string.app_name),
        theme: ThemeData(
          brightness: appSettings != null && appSettings.useDarkDisplay ? Brightness.dark : Brightness.light,
          primaryColor: Colors.green,
          primaryColorLight: Colors.green,
          primaryColorDark: Colors.green,
          toggleableActiveColor: Colors.green,
          accentColor: Colors.green,
          secondaryHeaderColor: Colors.green,
          textSelectionColor: Colors.green,
          backgroundColor: Colors.green,
          buttonColor: Colors.green,
          primarySwatch: Colors.green,
        ),
        home: HomePage(),
      );
    });
  }
}
