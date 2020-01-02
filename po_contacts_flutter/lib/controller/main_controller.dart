import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/po_constants.dart';

class MainController {
  static void showAboutDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(I18n.getString(I18n.string.about, POConstants.APP_VERSION)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(I18n.getString(I18n.string.about_message)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.ok)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
