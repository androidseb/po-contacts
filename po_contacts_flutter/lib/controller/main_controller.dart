import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/contacts_search_delegate.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/po_constants.dart';
import 'package:po_contacts_flutter/view/details/view_contact_page.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MainController {
  static MainController _controller;

  static MainController get() {
    if (_controller == null) {
      _controller = new MainController();
    }
    return _controller;
  }

  MainModel _model;
  ContactsSearchDelegate _contactsSearchDelegate;

  MainController() {
    this._model = MainModel();
    this._contactsSearchDelegate = ContactsSearchDelegate();
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
    _contactsSearchDelegate.close(context, null);
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
    _contactsSearchDelegate.close(context, null);
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

  void showTextInputDialog(
    final BuildContext context,
    final String hintStringKey,
    final Function(String enteredText) callback,
  ) {
    final String hintText = I18n.getString(hintStringKey);
    final TextEditingController textFieldController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(hintText),
            content: TextField(
              controller: textFieldController,
              decoration: InputDecoration(hintText: hintText),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(I18n.getString(I18n.string.ok)),
                onPressed: () {
                  Navigator.of(context).pop();
                  callback(textFieldController.value.text);
                },
              ),
            ],
          );
        });
  }

  void startPhoneCall(final String phoneNumber) {
    launch('tel:$phoneNumber');
  }

  void startSMS(final String phoneNumber) {
    launch('sms:$phoneNumber');
  }

  void startEmail(final String emailAddress) {
    launch('mailto:$emailAddress');
  }

  void showContactQuickActionsMenu(final BuildContext context, final Contact contact) {
    final List<Widget> listOptions = [];
    for (final LabeledField pi in contact.phoneInfos) {
      final String phoneStr = I18n.getString(LabeledField.getTypeNameStringKey(pi.labelType)) + ' (${pi.textValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.phone),
        title: Text(I18n.getString(I18n.string.call_x, phoneStr)),
        onTap: () {
          Navigator.of(context).pop();
          startPhoneCall(pi.textValue);
        },
      ));
      listOptions.add(ListTile(
        leading: Icon(Icons.message),
        title: Text(I18n.getString(I18n.string.text_x, phoneStr)),
        onTap: () {
          Navigator.of(context).pop();
          startSMS(pi.textValue);
        },
      ));
    }
    for (final LabeledField ei in contact.emailInfos) {
      final String emailStr = I18n.getString(LabeledField.getTypeNameStringKey(ei.labelType)) + ' (${ei.textValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.mail),
        title: Text(I18n.getString(I18n.string.email_x, emailStr)),
        onTap: () {
          Navigator.of(context).pop();
          startEmail(ei.textValue);
        },
      ));
    }
    listOptions.add(ListTile(
      leading: Icon(Icons.edit),
      title: Text(I18n.getString(I18n.string.edit_contact)),
      onTap: () {
        Navigator.of(context).pop();
        MainController.get().startEditContact(context, contact.id);
      },
    ));
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(I18n.getString(I18n.string.quick_actions)),
            content: ListView(
              padding: EdgeInsets.zero,
              children: listOptions,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void startSearch(final BuildContext context) {
    showSearch(context: context, delegate: _contactsSearchDelegate);
  }
}
