import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_file_writer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class ExportController {
  bool _isExporting = false;

  void exportAllAsVCF() async {
    if (_isExporting) {
      return;
    }
    _isExporting = true;
    final Function(int progress) progressCallback =
        MainController.get().displayLoadingDialog(I18n.getString(I18n.string.exporting));
    final String outputFilesDirPath =
        await MainController.get().psController.fileTransitManager.getOutputFilesDirectoryPath();
    final DateTime t = DateTime.now();
    final String monthS = Utils.positiveNumberToXDigitsString(t.month, 2);
    final String dayS = Utils.positiveNumberToXDigitsString(t.day, 2);
    final String hourS = Utils.positiveNumberToXDigitsString(t.hour, 2);
    final String minuteS = Utils.positiveNumberToXDigitsString(t.minute, 2);
    final String secondS = Utils.positiveNumberToXDigitsString(t.second, 2);
    final String dateTimeStr = '${t.year}$monthS${dayS}_$hourS$minuteS$secondS';
    final FileEntity destFile = await MainController.get()
        .psController
        .filesManager
        .createFileEntityParentAndName(outputFilesDirPath, 'contacts_$dateTimeStr.vcf');
    try {
      await _exportAllAsVCFToFile(destFile, progressCallback);
    } finally {
      _isExporting = false;
      progressCallback(101);
    }
    final String sharePromptTitle = I18n.getString(I18n.string.share_prompt_title);
    await MainController.get().psController.fileTransitManager.shareFileExternally(sharePromptTitle, destFile);
    if (MainController.get().psController.basicInfoManager.isAndroid) {
      MainController.get().showMessageDialog(
        I18n.getString(I18n.string.export_completed),
        I18n.getString(I18n.string.exported_contacts_to_file_x, destFile.getAbsolutePath()),
      );
    }
  }

  Future<void> _exportAllAsVCFToFile(final FileEntity outputFile, final Function(int progress) progressCallback) async {
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    await outputFile.create();
    final List<Contact> contacts = MainController.get().model.contactsList;
    final VCFWriter vcfWriter = VCFFileWriter(
      MainController.get().psController.filesManager,
      outputFile,
    );
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
      progressCallback,
    );
    await vcfWriter.flushOutputBuffer();
  }
}
