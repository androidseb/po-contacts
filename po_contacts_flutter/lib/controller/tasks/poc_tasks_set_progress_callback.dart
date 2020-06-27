import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/utils/main_queue_yielder.dart';
import 'package:po_contacts_flutter/utils/tasks_set_progress_callback.dart';

enum POCTask {
  TASK_CODE_EXPORTING,
  TASK_CODE_ENCRYPTING,
  TASK_CODE_READING,
  TASK_CODE_DECRYPTING,
  TASK_CODE_IMPORTING,
}

class POCTaskSetProgressCallback extends TaskSetProgressCallback {
  static const int TASK_PROGRESS_COMPLETED_SUCCESS = -1;
  static const int TASK_PROGRESS_COMPLETED_ERROR_IMPORT = -2;

  POCTaskSetProgressCallback(
      final List<POCTask> tasks, final Function(String i18nStringKey, int progress) progressCallback)
      : super(List<int>.generate(tasks.length, (i) => tasks[i].index), (int taskId, int progress) {
          String stringKey = '';
          if (taskId == POCTask.TASK_CODE_EXPORTING.index) {
            stringKey = I18n.string.task_exporting;
          } else if (taskId == POCTask.TASK_CODE_ENCRYPTING.index) {
            stringKey = I18n.string.task_encrypting;
          } else if (taskId == POCTask.TASK_CODE_READING.index) {
            stringKey = I18n.string.task_reading;
          } else if (taskId == POCTask.TASK_CODE_DECRYPTING.index) {
            stringKey = I18n.string.task_decrypting;
          } else if (taskId == POCTask.TASK_CODE_IMPORTING.index) {
            stringKey = I18n.string.task_importing;
          }
          progressCallback(stringKey, progress);
        });

  // Displays a loading dialog and returns a function to control updating the progress
  // Calling the function with a value of CODE_LOADING_OPERATION_FINISHED will terminate the loading dialog
  // Calling the function with a value of CODE_LOADING_OPERATION_IMPORT_ERROR will terminate the loading dialog and
  // display the message error for import errors
  // Calling the function with any other value will update the progress text with <value>%
  static POCTaskSetProgressCallback displayLoadingDialog(final List<POCTask> tasks) {
    final BuildContext context = MainController.get().context;
    final TextEditingController titleTextController = TextEditingController();
    titleTextController.text = I18n.getString(I18n.string.task_preparing);
    final TextEditingController percentageTextController = TextEditingController();
    showDialog<Object>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: titleTextController,
                  decoration: null,
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(),
                SizedBox(height: 16),
                TextField(
                  textAlign: TextAlign.center,
                  enabled: false,
                  controller: percentageTextController,
                ),
              ],
            ),
          ),
        );
      },
    );
    final TaskSetProgressCallback progressCallback =
        POCTaskSetProgressCallback(tasks, (final String stringKey, final int progress) async {
      await MainQueueYielder.check();
      if (progress < 0) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        if (progress == POCTaskSetProgressCallback.TASK_PROGRESS_COMPLETED_ERROR_IMPORT) {
          MainController.get().showMessageDialog(
            I18n.getString(I18n.string.import_error_title),
            I18n.getString(I18n.string.import_error_message),
          );
        }
      } else {
        titleTextController.text = I18n.getString(stringKey);
        percentageTextController.text = '$progress%';
      }
    });
    percentageTextController.text = '0%';
    return progressCallback;
  }
}
