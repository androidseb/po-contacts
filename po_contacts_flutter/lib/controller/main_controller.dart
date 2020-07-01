import 'dart:async';

import 'package:image/image.dart' as dartImgLib;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/contacts_search_delegate.dart';
import 'package:po_contacts_flutter/controller/export_controller.dart';
import 'package:po_contacts_flutter/controller/import_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/poc_sync_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/model/main_model.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_controller.dart';
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
  final POCSyncController _syncController = POCSyncController();

  void _initializeMainController() {
    _model.initializeMainModel(_psController.contactsStorage);
    SystemChannels.lifecycle.setMessageHandler((final String msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {
        _importController.startImportIfNeeded();
      }
      return msg;
    });
    _importController.startImportIfNeeded();
    _syncController.initializeSyncController(model);
  }

  BuildContext get context => _context;

  MainModel get model => _model;

  PlatformSpecificController get psController => _psController;

  POCSyncController get syncController => _syncController;

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
    if (syncController.syncState != SyncState.SYNC_IDLE) {
      syncController.promptUserActionCanceledBySync();
      return;
    }
    Navigator.push<Object>(_context, MaterialPageRoute(
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

  void saveContact(final int contactId, final ContactData targetContactData) {
    if (_context == null) {
      return;
    }
    if (contactId == null && targetContactData == null) {
      return;
    }
    if (targetContactData == null) {
      return;
    }
    if (contactId == null) {
      this._model.addContact(targetContactData);
    } else {
      this._model.overwriteContact(contactId, targetContactData);
    }
    Navigator.pop(_context);
  }

  void startViewContact(final int contactId) {
    if (_context == null) {
      return;
    }
    _contactsSearchDelegate.close(_context, null);
    Navigator.push<Object>(_context, MaterialPageRoute(
      builder: (final BuildContext context) {
        return ViewContactPage(contactId);
      },
    ));
  }

  void startDeleteContact(final int contactId) async {
    if (_context == null) {
      return;
    }

    if (syncController.syncState != SyncState.SYNC_IDLE) {
      syncController.promptUserActionCanceledBySync();
      return;
    }

    final bool userConfirmedDeletion = await promptUserForYesNoQuestion(
      titleText: I18n.getString(I18n.string.delete_contact),
      messageText: I18n.getString(I18n.string.delete_contact_confirmation_message),
      barrierDismissible: true,
    );

    if (userConfirmedDeletion) {
      this._model.deleteContact(contactId);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  Future<String> promptUserForPasswordUsage({
    @required final String promptTitle,
    @required final String promptMessage,
    final bool barrierDismissible = false,
  }) async {
    final Completer<String> passwordCompleter = Completer<String>();
    if (_context == null) {
      return passwordCompleter.future;
    }
    showDialog<Object>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(promptTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(promptMessage),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.encrypt_option_unprotected)),
              onPressed: () {
                Navigator.of(context).pop();
                passwordCompleter.complete(null);
              },
            ),
            FlatButton(
              child: Text(I18n.getString(I18n.string.encrypt_option_encrypted)),
              onPressed: () async {
                Navigator.of(context).pop();
                final String encryptionKey = await showTextInputDialog(
                  I18n.getString(I18n.string.enter_password),
                  isPassword: true,
                );
                if (encryptionKey == null || encryptionKey.isEmpty) {
                  return;
                }
                passwordCompleter.complete(encryptionKey);
              },
            ),
          ],
        );
      },
    );
    return passwordCompleter.future;
  }

  void startExportAllAsVCF() async {
    final String encryptionPassword = await promptUserForPasswordUsage(
      promptTitle: I18n.getString(I18n.string.export_all_as_vcf),
      promptMessage: I18n.getString(I18n.string.export_encrypt_question),
    );
    _exportController.exportAllAsVCF(encryptionPassword);
  }

  void showMessageDialog(final String title, final String message) {
    showDialog<Object>(
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
    showDialog<Object>(
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
    showDialog<Object>(
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

  Future<bool> promptUserForYesNoQuestion({
    @required final String titleText,
    @required final String messageText,
    final bool barrierDismissible = false,
  }) {
    final Completer<bool> userResponseCompleter = Completer<bool>();
    showDialog<Object>(
      context: _context,
      barrierDismissible: barrierDismissible,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(messageText),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(I18n.getString(I18n.string.no)),
              onPressed: () {
                Navigator.of(context).pop();
                userResponseCompleter.complete(false);
              },
            ),
            FlatButton(
              child: Text(I18n.getString(I18n.string.yes)),
              onPressed: () {
                Navigator.of(context).pop();
                userResponseCompleter.complete(true);
              },
            ),
          ],
        );
      },
    );
    return userResponseCompleter.future;
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

  Future<FileEntity> pickImageFile({final int maxSize = null}) async {
    final FileEntity selectedImageFile = await _pickImageFileWithOS();
    if (selectedImageFile == null) {
      return null;
    }

    if (maxSize != null) {
      await _resizeImage(selectedImageFile, maxSize);
    }

    final String fileExtension = Utils.getFileExtension(selectedImageFile.getAbsolutePath());
    if (!MainController.ALLOWED_IMAGE_EXTENSIONS.contains(fileExtension.toLowerCase())) {
      return null;
    }

    return selectedImageFile;
  }

  Future<void> _resizeImage(final FileEntity imageFile, final int maxSize) async {
    showDialog<Object>(
      context: _context,
      barrierDismissible: false,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text(I18n.getString(I18n.string.importing_image_title)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(I18n.getString(I18n.string.importing_image_message)),
              ],
            ),
          ),
        );
      },
    );
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      final dartImgLib.Image image = dartImgLib.decodeImage(await imageFile.readAsBinaryData());
      if (image.width > maxSize || image.height > maxSize) {
        dartImgLib.Image thumbnail;
        if (image.width > image.height) {
          thumbnail = dartImgLib.copyResize(image, width: maxSize);
        } else {
          thumbnail = dartImgLib.copyResize(image, height: maxSize);
        }
        imageFile.writeAsUint8List(dartImgLib.encodePng(thumbnail));
      }
    } finally {
      Navigator.pop(context);
    }
  }

  Future<FileEntity> _pickImageFileWithOS() async {
    if (_context == null) {
      return null;
    }
    if (psController.basicInfoManager.isDesktop) {
      return psController.filesManager.pickImageFile(ImageFileSource.FILE_PICKER);
    }
    final Completer<FileEntity> futureSelectedFile = Completer<FileEntity>();
    showDialog<Object>(
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
    Navigator.push<Object>(_context, MaterialPageRoute(
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
        leading: c.iconData == null ? null : Icon(c.iconData),
        title: Text(c.entryLabel),
        onTap: () async {
          Navigator.of(_context).pop();
          if (c.onSelected != null) {
            c.onSelected();
          }
          futureSelectedChoice.complete(c);
        },
      ));
    }
    showDialog<Object>(
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
