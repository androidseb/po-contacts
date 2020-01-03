import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/view/main_view.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: I18n.getString(I18n.string.app_name),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainView(title: I18n.getString(I18n.string.app_name)),
    );
  }
}
