import 'dart:io';

import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_file_writer.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class ExportController {
  bool _isExporting = false;

  void exportAllAsVCF() async {
    if (_isExporting) {
      return;
    }
    _isExporting = true;
    final Function(int progress) progressCallback =
        MainController.get().displayLoadingDialog(I18n.getString(I18n.string.exporting));
    final String outputFilesDirPath = await MainController.get().nativeApisController.getOutputFilesDirectoryPath();
    final DateTime t = new DateTime.now();
    //TODO timestamp add 0s when needed
    final String dateTimeStr = '${t.year}_${t.month}_${t.day}_${t.hour}_${t.minute}_${t.second}';
    final String destFilePath = '$outputFilesDirPath/contacts_$dateTimeStr.vcf';
    final File destFile = new File(destFilePath);
    try {
      await _exportAllAsVCFToFile(destFile, progressCallback);
      if (Platform.isAndroid) {
        MainController.get().showMessageDialog(
          I18n.getString(I18n.string.export_completed),
          I18n.getString(I18n.string.exported_contacts_to_file_x, destFilePath),
        );
      }
      final String sharePromptTitle = I18n.getString(I18n.string.share_prompt_title);
      await MainController.get().nativeApisController.shareFileExternally(sharePromptTitle, destFilePath);
    } finally {
      _isExporting = false;
      progressCallback(101);
    }
  }

  _exportAllAsVCFToFile(final File outputFile, final Function(int progress) progressCallback) async {
    if (outputFile.existsSync()) {
      outputFile.deleteSync();
    }
    outputFile.createSync();
    final List<Contact> contacts = MainController.get().model.contactsList;
    VCFSerializer.writeToVCF(contacts, new VCFFileWriter(outputFile), progressCallback);
  }
}
