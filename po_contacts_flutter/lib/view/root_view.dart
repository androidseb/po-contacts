import 'dart:async';

import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:po_contacts_flutter/view/home/home_page.dart';

class RootView extends StatefulWidget {
  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  StreamSubscription<AppSettings> _useDarkDisplayStreamSubscription;
  bool _useDarkDisplay = MainController.get().model.settings.appSettings.useDarkDisplay;

  @override
  void initState() {
    _useDarkDisplayStreamSubscription =
        MainController.get().model.settings.appSettingsChangeStream.listen((final AppSettings appSettings) {
      setState(() {
        _useDarkDisplay = appSettings.useDarkDisplay;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _useDarkDisplayStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: I18n.getString(I18n.string.app_name),
      theme: ThemeData(
        brightness: _useDarkDisplay ? Brightness.dark : Brightness.light,
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
  }
}
