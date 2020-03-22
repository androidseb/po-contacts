import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/js_api.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/utils.web.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';

class ActionsManagerWeb extends ActionsManager {
  @override
  void copyTextToClipBoard(final String text) {
    UtilsWeb.copyTextToClipBoard(text);
  }

  @override
  void startEmail(final String targetEmailAddress) {
    final int emailActionId = MainController.get().model.settings.appSettings.emailActionId;
    if (emailActionId == AppSettings.EMAIL_ACTION_THUNDERBIRD) {
      POCJSAPI.executeShellCommand('thunderbird -compose to="$targetEmailAddress"');
    }
  }

  @override
  void startPhoneCallImpl(final String targetPhoneNumber) {
    final int callActionId = MainController.get().model.settings.appSettings.callActionId;
    if (callActionId == AppSettings.CALL_ACTION_LINPHONE) {
      POCJSAPI.executeShellCommand('linphone -c $targetPhoneNumber');
    }
  }

  @override
  void startSMSImpl(final String targetPhoneNumber) {
    //This action is not supported on the web
  }
}
