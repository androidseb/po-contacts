import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/disk_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

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

  Future<void> _importFileWithId(final String fileId) async {
    bool importSuccessful = false;
    final Function(int progress) progressCallback =
        MainController.get().displayLoadingDialog(I18n.getString(I18n.string.importing));
    try {
      final String inboxFilePath =
          await MainController.get().psController.fileTransitManager.getCopiedInboxFilePath(fileId);
      final FileEntity file =
          await MainController.get().psController.filesManager.createFileEntityAbsPath(inboxFilePath);
      final List<ContactBuilder> readContacts = await VCFSerializer.readFromVCF(
        VCFFileReader(
          file,
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
