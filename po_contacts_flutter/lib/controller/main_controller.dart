import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/po_constants.dart';
import 'package:po_contacts_flutter/view/details/view_contact_page.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_page.dart';

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

  void _startEditContact(final BuildContext context, final int contactId) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return EditContactPage(contactId);
      },
    ));
  }

  void startAddContact(final BuildContext context) {
    _startEditContact(context, null);
  }

  void startEditContact(final BuildContext context, final int contactId) {
    _startEditContact(context, contactId);
  }

  void saveContact(final BuildContext context, final int contactId, final ContactBuilder targetContactBuilder) {
    if (contactId == null && targetContactBuilder == null) {
      return;
    }
    if (targetContactBuilder == null) {
      return;
    }
    if (contactId == null) {
      this._model.addContact(targetContactBuilder);
    } else {
      this._model.overwriteContact(contactId, targetContactBuilder);
    }
    Navigator.pop(context);
  }

  void startViewContact(final BuildContext context, final int contactId) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return ViewContactPage(contactId);
      },
    ));
  }

  void startDeleteContact(final BuildContext context, final int contactId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(I18n.getString(I18n.string.delete_contact)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(I18n.getString(I18n.string.delete_contact_confirmation_message)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.no)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(I18n.getString(I18n.string.yes)),
              onPressed: () {
                Navigator.of(context).pop();
                this._model.deleteContact(contactId);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
