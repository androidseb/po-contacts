import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/view/settings/pref_for_call_action.dart';
import 'package:po_contacts_flutter/view/settings/pref_for_email_action.dart';
import 'package:po_contacts_flutter/view/settings/pref_for_scrollbar.dart';

class SettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.getString(I18n.string.settings)),
      ),
      body: ListView(
        children: [
          PrefForScrollbar(),
          PrefForEmailAction(),
          PrefForCallAction(),
        ],
      ),
    );
  }
}
