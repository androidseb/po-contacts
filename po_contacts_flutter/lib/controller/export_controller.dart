import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/tasks/poc_tasks_set_progress_callback.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_file_writer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/tasks_set_progress_callback.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class ExportController {
  bool _isExporting = false;

  void exportAllAsVCF(final String encryptionKey) async {
    if (_isExporting) {
      return;
    }
    _isExporting = true;
    final List<POCTask> tasks = [];
    tasks.add(POCTask.TASK_CODE_EXPORTING);
    if (encryptionKey != null) {
      tasks.add(POCTask.TASK_CODE_ENCRYPTING);
      tasks.add(POCTask.TASK_CODE_ENCRYPTING);
    }
    final TaskSetProgressCallback progressCallback = POCTaskSetProgressCallback.displayLoadingDialog(tasks);
    final String outputFilesDirPath =
        await MainController.get().psController.fileTransitManager.getOutputFilesDirectoryPath();
    final String dateTimeStr = Utils.dateTimeToString();
    final FileEntity destFile = await MainController.get()
        .psController
        .filesManager
        .createFileEntityParentAndName(outputFilesDirPath, 'contacts_$dateTimeStr.vcf');
    try {
      await _exportAllAsVCFToFile(destFile, encryptionKey, progressCallback);
    } finally {
      _isExporting = false;
      progressCallback.reportAllTasksFinished(POCTaskSetProgressCallback.TASK_PROGRESS_COMPLETED_SUCCESS);
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

  Future<void> _exportAllAsVCFToFile(
    final FileEntity outputFile,
    final String encryptionKey,
    final TaskSetProgressCallback progressCallback,
  ) async {
    if (await outputFile.exists()) {
      await outputFile.delete();
    }
    await outputFile.create();
    final List<Contact> contacts = MainController.get().model.contactsList;
    final VCFWriter vcfWriter = VCFFileWriter(
      MainController.get().psController.filesManager,
      outputFile,
      encryptionKey,
    );
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
      progressCallback,
    );
    await progressCallback.reportOneTaskCompleted();
    await vcfWriter.flushOutputBuffer(progressCallback);
  }
}
