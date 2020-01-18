import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/contacts_search_delegate.dart';
import 'package:po_contacts_flutter/controller/export_controller.dart';
import 'package:po_contacts_flutter/controller/import_controller.dart';
import 'package:po_contacts_flutter/controller/native_apis_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/view/details/view_contact_page.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class MainController {
  static MainController _controller;

  static MainController get() {
    if (_controller == null) {
      _controller = MainController();
      _controller._initializeMainController();
    }
    return _controller;
  }

  BuildContext _context;
  final MainModel _model = MainModel();
  final ContactsSearchDelegate _contactsSearchDelegate = ContactsSearchDelegate();
  final NativeApisController _nativeApisController = NativeApisController();
  final ImportController _importController = ImportController();
  final ExportController _exportController = ExportController();

  void _initializeMainController() {
    SystemChannels.lifecycle.setMessageHandler((final String msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _importController.startImportIfNeeded();
      }
      return msg;
    });
    _importController.startImportIfNeeded();
  }

  MainModel get model => _model;

  NativeApisController get nativeApisController => _nativeApisController;

  //Releases the current execution thread to allow other queued items to execute
  //Used during file import/export operations
  Future<void> yieldMainQueue() async {
    return await _nativeApisController.getOutputFilesDirectoryPath();
  }

  void updateBuildContext(final BuildContext context) {
    if (context == null) {
      return;
    }
    _context = context;
  }

  void _startEditContact(final int contactId) {
    if (_context == null) {
      return;
    }
    Navigator.push(_context, MaterialPageRoute(
      builder: (final BuildContext context) {
        return EditContactPage(contactId);
      },
    ));
  }

  void startAddContact() {
    if (_context == null) {
      return;
    }
    _startEditContact(null);
  }

  void startEditContact(final int contactId) {
    if (_context == null) {
      return;
    }
    _contactsSearchDelegate.close(_context, null);
    _startEditContact(contactId);
  }

  void saveContact(final int contactId, final ContactBuilder targetContactBuilder) {
    if (_context == null) {
      return;
    }
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
    Navigator.pop(_context);
  }

  void startViewContact(final int contactId) {
    if (_context == null) {
      return;
    }
    _contactsSearchDelegate.close(_context, null);
    Navigator.push(_context, MaterialPageRoute(
      builder: (final BuildContext context) {
        return ViewContactPage(contactId);
      },
    ));
  }

  void startDeleteContact(final int contactId) {
    if (_context == null) {
      return;
    }
    showDialog(
      context: _context,
      builder: (final BuildContext context) {
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
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void startExportAllAsVCF() {
    _exportController.exportAllAsVCF();
  }

  void showAboutDialog() {
    showMessageDialog(
      I18n.getString(I18n.string.about, MainController.get().model.appVersion),
      I18n.getString(I18n.string.about_message),
    );
  }

  void showMessageDialog(final String title, final String message) {
    showDialog(
      context: _context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
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
    final String hintStringKey,
    final Function(String enteredText) callback,
  ) {
    if (_context == null) {
      return;
    }
    final String hintText = I18n.getString(hintStringKey);
    final TextEditingController textFieldController = TextEditingController();
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: Text(hintText),
            content: TextField(
              controller: textFieldController,
              decoration: InputDecoration(hintText: hintText),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(I18n.getString(I18n.string.ok)),
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

  void showContactQuickActionsMenu(final Contact contact) {
    if (_context == null) {
      return;
    }
    final List<Widget> listOptions = [];
    for (final StringLabeledField pi in contact.phoneInfos) {
      final String phoneStr = I18n.getString(LabeledField.getTypeNameStringKey(pi.labelType)) + ' (${pi.fieldValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.phone),
        title: Text(I18n.getString(I18n.string.call_x, phoneStr)),
        onTap: () {
          Navigator.of(_context).pop();
          startPhoneCall(pi.fieldValue);
        },
      ));
      listOptions.add(ListTile(
        leading: Icon(Icons.message),
        title: Text(I18n.getString(I18n.string.text_x, phoneStr)),
        onTap: () {
          Navigator.of(_context).pop();
          startSMS(pi.fieldValue);
        },
      ));
    }
    for (final StringLabeledField ei in contact.emailInfos) {
      final String emailStr = I18n.getString(LabeledField.getTypeNameStringKey(ei.labelType)) + ' (${ei.fieldValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.mail),
        title: Text(I18n.getString(I18n.string.email_x, emailStr)),
        onTap: () {
          Navigator.of(_context).pop();
          startEmail(ei.fieldValue);
        },
      ));
    }
    listOptions.add(ListTile(
      leading: Icon(Icons.edit),
      title: Text(I18n.getString(I18n.string.edit_contact)),
      onTap: () {
        Navigator.of(_context).pop();
        MainController.get().startEditContact(contact.id);
      },
    ));
    listOptions.add(ListTile(
      leading: Icon(Icons.delete),
      title: Text(I18n.getString(I18n.string.delete_contact)),
      onTap: () {
        Navigator.of(_context).pop();
        MainController.get().startDeleteContact(contact.id);
      },
    ));
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: Text(I18n.getString(I18n.string.quick_actions)),
            content: SingleChildScrollView(
              child: ListBody(
                children: listOptions,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void startSearch() {
    if (_context == null) {
      return;
    }
    showSearch(context: _context, delegate: _contactsSearchDelegate);
  }

  void promptUserForFileImport(final Function(bool approved) userApprovedImportCallback) {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(I18n.getString(I18n.string.import_file_title)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(I18n.getString(I18n.string.import_file_question)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.no)),
              onPressed: () {
                Navigator.of(context).pop();
                userApprovedImportCallback(false);
              },
            ),
            FlatButton(
              child: Text(I18n.getString(I18n.string.yes)),
              onPressed: () {
                Navigator.of(context).pop();
                userApprovedImportCallback(true);
              },
            ),
          ],
        );
      },
    );
  }

  // Displays a loading dialog and returns a function to control updating the progress
  // Calling the function with a value of 101 will terminate the loading dialog
  // Calling the function with any other value will update the progress text with <value>%
  Future<void> Function(int progress) displayLoadingDialog(final String title) {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title),
                SizedBox(height: 16),
                CircularProgressIndicator(),
                TextField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: textController,
                ),
              ],
            ),
          ),
        );
      },
    );
    final Future<void> Function(int progress) progressCallback = (final int progress) async {
      await yieldMainQueue();
      if (progress == 101) {
        if (Navigator.canPop(_context)) {
          Navigator.pop(_context);
        }
      } else {
        textController.text = '$progress%';
      }
    };
    textController.text = '0%';
    return progressCallback;
  }
}
