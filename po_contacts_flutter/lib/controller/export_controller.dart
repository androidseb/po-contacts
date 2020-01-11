import 'dart:io';

import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';

class ExportController {
  void exportAllAsVCF() async {
    final String outputFilesDirPath = await MainController.get().nativeApisController.getOutputFilesDirectoryPath();
    final DateTime t = new DateTime.now();
    final String dateTimeStr = '${t.year}_${t.month}_${t.day}_${t.hour}_${t.minute}_${t.second}';
    final String destFilePath = '$outputFilesDirPath/contacts_$dateTimeStr.vcf';
    final File destFile = new File(destFilePath);
    await _exportAllAsVCFToFile(destFile);
    final String sharePromptTitle = I18n.getString(I18n.string.share_prompt_title);
    await MainController.get().nativeApisController.shareFileExternally(sharePromptTitle, destFilePath);
  }

  _exportAllAsVCFToFile(final File outputFile) async {
    if (outputFile.existsSync()) {
      outputFile.deleteSync();
    }
    outputFile.createSync();
    //TODO actually write contacts as VCF
    outputFile.writeAsStringSync('Some string');
  }
}
