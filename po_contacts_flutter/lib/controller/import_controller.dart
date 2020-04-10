import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/disk_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class ImportController {
  bool _currentlyImporting = false;

  void startImportIfNeeded() {
    _getImportableFileId().then((final String fileId) {
      _startImportProcedure(fileId);
    });
  }

  Future<String> _getImportableFileId() async {
    return await MainController.get().psController.fileTransitManager.getInboxFileId();
  }

  void _startImportProcedure(final String fileId) {
    if (fileId == null) {
      return;
    }
    if (_currentlyImporting) {
      return;
    }
    _currentlyImporting = true;

    MainController.get().promptUserForFileImport((userApprovedImport) async {
      if (userApprovedImport) {
        _importFileWithId(fileId);
        MainController.get().yieldMainQueue();
      } else {
        _discardFileWithId(fileId);
        _currentlyImporting = false;
      }
    });
  }

  void _discardFileWithId(final String fileId) {
    MainController.get().psController.fileTransitManager.discardInboxFileId(fileId);
  }

  Future<bool> isFileEncrypted(final FileEntity file) async {
    final String fileBase64String = await file.readAsBase64String();
    final Uint8List encryptionFlagHeaderContent = utf8.encode(VCFSerializer.ENCRYPTED_FILE_PREFIX);
    final Uint8List fileRawContent = base64.decode(fileBase64String);
    if (fileRawContent.length < encryptionFlagHeaderContent.length) {
      return false;
    }
    final Uint8List fileHeaderContent = fileRawContent.sublist(0, encryptionFlagHeaderContent.length);
    return Utils.areUInt8ListsEqual(fileHeaderContent, encryptionFlagHeaderContent);
  }

  Future<void> _importFileWithId(final String fileId) async {
    bool importSuccessful = false;
    final Function(int progress) progressCallback =
        MainController.get().displayLoadingDialog(I18n.getString(I18n.string.importing));
    try {
      final String inboxFilePath =
          await MainController.get().psController.fileTransitManager.getCopiedInboxFilePath(fileId);
      final FileEntity file =
          await MainController.get().psController.filesManager.createFileEntityAbsPath(inboxFilePath);
      String encryptionKey;
      if (await isFileEncrypted(file)) {
        encryptionKey = await MainController.get()
            .showTextInputDialog(I18n.getString(I18n.string.enter_password), isPassword: true);
        if (encryptionKey == null || encryptionKey.isEmpty) {
          return;
        }
      }
      final List<ContactBuilder> readContacts = await VCFSerializer.readFromVCF(
        VCFFileReader(
          file,
          encryptionKey,
          DiskFileInflater(),
          progressCallback: progressCallback,
        ),
      );
      for (final ContactBuilder cb in readContacts) {
        await MainController.get().model.addContact(cb);
      }
      importSuccessful = true;
    } finally {
      _discardFileWithId(fileId);
      _currentlyImporting = false;
      if (importSuccessful) {
        progressCallback(MainController.CODE_LOADING_OPERATION_FINISHED);
      } else {
        progressCallback(MainController.CODE_LOADING_OPERATION_IMPORT_ERROR);
      }
    }
    return importSuccessful;
  }
}
