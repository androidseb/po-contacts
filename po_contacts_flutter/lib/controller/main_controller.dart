import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/app_version.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/contacts_search_delegate.dart';
import 'package:po_contacts_flutter/controller/export_controller.dart';
import 'package:po_contacts_flutter/controller/import_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'package:po_contacts_flutter/view/details/view_contact_page.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_page.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';
import 'package:po_contacts_flutter/view/settings/settings_page.dart';

class MainController {
  static const ALLOWED_IMAGE_EXTENSIONS = ['.png', '.jpg', '.jpeg'];

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
  final PlatformSpecificController _psController = PlatformSpecificController();
  final ImportController _importController = ImportController();
  final ExportController _exportController = ExportController();

  void _initializeMainController() {
    _model.initializeMainModel(_psController.contactsStorage);
    SystemChannels.lifecycle.setMessageHandler((final String msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _importController.startImportIfNeeded();
      }
      return msg;
    });
    _importController.startImportIfNeeded();
  }

  MainModel get model => _model;

  PlatformSpecificController get psController => _psController;

  //Releases the current execution thread to allow other queued items to execute
  //Used during file import/export operations
  Future<void> yieldMainQueue() async {
    return await _psController.fileTransitManager.getOutputFilesDirectoryPath();
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
    if (_context == null) {
      return;
    }
    showDialog(
      context: _context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(I18n.getString(I18n.string.export_all_as_vcf)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(I18n.getString(I18n.string.export_encrypt_question)),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.export_encrypt_option_unprotected)),
              onPressed: () {
                Navigator.of(context).pop();
                _exportController.exportAllAsVCF(null);
              },
            ),
            FlatButton(
              child: Text(I18n.getString(I18n.string.export_encrypt_option_encrypted)),
              onPressed: () async {
                Navigator.of(context).pop();
                final String encryptionKey = await showTextInputDialog(
                  I18n.getString(I18n.string.enter_password),
                  isPassword: true,
                );
                if (encryptionKey == null || encryptionKey.isEmpty) {
                  return;
                }
                _exportController.exportAllAsVCF(encryptionKey);
              },
            ),
          ],
        );
      },
    );
  }

  void showAboutDialog() {
    showMessageDialog(
      I18n.getString(I18n.string.about, PO_APP_VERSION),
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

  Future<String> showTextInputDialog(
    final String hintStringKey, {
    bool isPassword: false,
  }) async {
    if (_context == null) {
      return null;
    }
    final Completer<String> futureEnteredText = Completer<String>();
    final String hintText = I18n.getString(hintStringKey);
    final TextEditingController textFieldController = TextEditingController();
    showDialog(
        context: _context,
        builder: (context) {
          return AlertDialog(
            title: Text(hintText),
            content: TextField(
              autofocus: true,
              obscureText: isPassword,
              controller: textFieldController,
              decoration: InputDecoration(hintText: hintText),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                  futureEnteredText.complete(null);
                },
              ),
              FlatButton(
                child: Text(I18n.getString(I18n.string.ok)),
                onPressed: () {
                  Navigator.of(context).pop();
                  futureEnteredText.complete(textFieldController.value.text);
                },
              ),
            ],
          );
        });
    return futureEnteredText.future;
  }

  void showContactQuickActionsMenu(final Contact contact) {
    if (_context == null) {
      return;
    }
    final List<Widget> listOptions = [];
    for (final StringLabeledField pi in contact.phoneInfos) {
      final String phoneStr = LabeledField.getLabelTypeDisplayText(pi) + ' (${pi.fieldValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.content_copy),
        title: Text(I18n.getString(I18n.string.copy_to_clipboard_x, phoneStr)),
        onTap: () {
          Navigator.of(_context).pop();
          psController.actionsManager.copyTextToClipBoard(pi.fieldValue);
        },
      ));
      listOptions.add(ListTile(
        leading: Icon(Icons.phone),
        title: Text(I18n.getString(I18n.string.call_x, phoneStr)),
        onTap: () {
          Navigator.of(_context).pop();
          psController.actionsManager.startPhoneCall(pi.fieldValue);
        },
      ));
      if (MainController.get().psController.basicInfoManager.isNotDesktop) {
        listOptions.add(ListTile(
          leading: Icon(Icons.message),
          title: Text(I18n.getString(I18n.string.text_x, phoneStr)),
          onTap: () {
            Navigator.of(_context).pop();
            psController.actionsManager.startSMS(pi.fieldValue);
          },
        ));
      }
    }
    for (final StringLabeledField ei in contact.emailInfos) {
      final String emailStr = LabeledField.getLabelTypeDisplayText(ei) + ' (${ei.fieldValue})';
      listOptions.add(ListTile(
        leading: Icon(Icons.content_copy),
        title: Text(I18n.getString(I18n.string.copy_to_clipboard_x, emailStr)),
        onTap: () {
          Navigator.of(_context).pop();
          psController.actionsManager.copyTextToClipBoard(ei.fieldValue);
        },
      ));
      listOptions.add(ListTile(
        leading: Icon(Icons.mail),
        title: Text(I18n.getString(I18n.string.email_x, emailStr)),
        onTap: () {
          Navigator.of(_context).pop();
          psController.actionsManager.startEmail(ei.fieldValue);
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

  static const int CODE_LOADING_OPERATION_FINISHED = -1;
  static const int CODE_LOADING_OPERATION_IMPORT_ERROR = -2;
  // Displays a loading dialog and returns a function to control updating the progress
  // Calling the function with a value of CODE_LOADING_OPERATION_FINISHED will terminate the loading dialog
  // Calling the function with a value of CODE_LOADING_OPERATION_IMPORT_ERROR will terminate the loading dialog and
  // display the message error for import errors
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
      if (progress < 0) {
        if (Navigator.canPop(_context)) {
          Navigator.pop(_context);
        }
        if (progress == CODE_LOADING_OPERATION_IMPORT_ERROR) {
          MainController.get().showMessageDialog(
            I18n.getString(I18n.string.import_error_title),
            I18n.getString(I18n.string.import_error_message),
          );
        }
      } else {
        textController.text = '$progress%';
      }
    };
    textController.text = '0%';
    return progressCallback;
  }

  Future<FileEntity> createNewImageFile(final String fileExtension) async {
    if (!MainController.ALLOWED_IMAGE_EXTENSIONS.contains(fileExtension.toLowerCase())) {
      return null;
    }
    final String internalAppDirectoryPath = await psController.filesManager.getApplicationDocumentsDirectoryPath();
    while (true) {
      final String targetFileName = '${Utils.currentTimeMillis()}$fileExtension';
      final FileEntity fileEntity = await MainController.get()
          .psController
          .filesManager
          .createFileEntityParentAndName(internalAppDirectoryPath, targetFileName);
      if (!await fileEntity.exists()) {
        await fileEntity.create();
        return fileEntity;
      }
    }
  }

  Future<FileEntity> pickImageFile() async {
    final FileEntity selectedImageFile = await _pickImageFileWithOS();
    if (selectedImageFile == null) {
      return null;
    }

    final String fileExtension = Utils.getFileExtension(selectedImageFile.getAbsolutePath());
    if (!MainController.ALLOWED_IMAGE_EXTENSIONS.contains(fileExtension.toLowerCase())) {
      return null;
    }

    return selectedImageFile;
  }

  Future<FileEntity> _pickImageFileWithOS() async {
    if (_context == null) {
      return null;
    }
    if (psController.basicInfoManager.isDesktop) {
      return psController.filesManager.pickImageFile(ImageFileSource.FILE_PICKER);
    }
    final Completer<FileEntity> futureSelectedFile = Completer<FileEntity>();
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(I18n.getString(I18n.string.select_image)),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text(I18n.getString(I18n.string.from_gallery)),
                    onTap: () async {
                      Navigator.of(_context).pop();
                      futureSelectedFile
                          .complete(await psController.filesManager.pickImageFile(ImageFileSource.GALLERY));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text(I18n.getString(I18n.string.from_camera)),
                    onTap: () async {
                      Navigator.of(_context).pop();
                      futureSelectedFile
                          .complete(await psController.filesManager.pickImageFile(ImageFileSource.CAMERA));
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                  futureSelectedFile.complete(null);
                },
              ),
            ],
          );
        });
    return futureSelectedFile.future;
  }

  void startImportVCF() async {
    if (psController.basicInfoManager.isNotDesktop) {
      showMessageDialog(
        I18n.getString(I18n.string.import_file_title),
        I18n.getString(I18n.string.import_file_mobile_helper_text),
      );
      return;
    }
    await psController.fileTransitManager.getCopiedInboxFilePath(null);
    _importController.startImportIfNeeded();
  }

  void openSettingsPage() {
    if (_context == null) {
      return;
    }
    Navigator.push(_context, MaterialPageRoute(
      builder: (final BuildContext context) {
        return SettingsPage();
      },
    ));
  }

  Future<MultiSelectionChoice> promptMultiSelection(
      final String title, final List<MultiSelectionChoice> availableEntries) async {
    final Completer<MultiSelectionChoice> futureSelectedChoice = Completer<MultiSelectionChoice>();
    final List<Widget> choicesWidgets = [];
    for (final MultiSelectionChoice c in availableEntries) {
      choicesWidgets.add(ListTile(
        title: Text(c.entryLabel),
        onTap: () async {
          Navigator.of(_context).pop();
          futureSelectedChoice.complete(c);
        },
      ));
    }
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: choicesWidgets,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(I18n.getString(I18n.string.cancel)),
                onPressed: () {
                  Navigator.of(context).pop();
                  futureSelectedChoice.complete(null);
                },
              ),
            ],
          );
        });
    return futureSelectedChoice.future;
  }
}
