import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/po_constants.dart';

class MainController {
  static MainController _controller;

  static MainController get() {
    if (_controller == null) {
      _controller = new MainController();
    }
    return _controller;
  }

  MainModel _model;

  MainController() {
    this._model = new MainModel();
  }

  MainModel get model => _model;

  void startAddContact() {
    //TODO
    final int epochMillis = new DateTime.now().millisecondsSinceEpoch;
    this._model.addContact(new ContactBuilder().setFirstName('First $epochMillis').setLastName('Last $epochMillis'));
  }

  void startExportAllAsVCF() {
    //TODO
  }

  void showAboutDialog(final BuildContext context) {
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
