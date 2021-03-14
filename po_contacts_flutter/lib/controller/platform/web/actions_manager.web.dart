import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/js_api.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/utils.web.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';

class ActionsManagerWeb extends ActionsManager {
  static void _startEmailWithSystemDefault(final String? targetEmailAddress) {
    final String mailToLink = 'mailto:$targetEmailAddress';
    final BasicInfoManager bim = MainController.get()!.psController.basicInfoManager!;
    if (bim.isLinux!) {
      POCJSAPI.executeShellCommand('xdg-open $mailToLink');
    } else if (bim.isMacOS!) {
      POCJSAPI.executeShellCommand('open $mailToLink');
    } else if (bim.isWindows!) {
      POCJSAPI.executeShellCommand('start $mailToLink');
    }
  }

  static void _startPhoneWithSystemDefault(final String targetPhoneNumber) {
    final String telLink = 'tel:$targetPhoneNumber';
    final BasicInfoManager bim = MainController.get()!.psController.basicInfoManager!;
    if (bim.isLinux!) {
      POCJSAPI.executeShellCommand('xdg-open $telLink');
    } else if (bim.isMacOS!) {
      POCJSAPI.executeShellCommand('open $telLink');
    } else if (bim.isWindows!) {
      POCJSAPI.executeShellCommand('start $telLink');
    }
  }

  @override
  void copyTextToClipBoard(final String? text) {
    UtilsWeb.copyTextToClipBoard(text);
  }

  @override
  void startEmail(final String? targetEmailAddress) {
    final int emailActionId = MainController.get()!.model.settings.appSettings!.emailActionId;
    if (emailActionId == AppSettings.EMAIL_ACTION_SYSTEM_DEFAULT) {
      _startEmailWithSystemDefault(targetEmailAddress);
    } else if (emailActionId == AppSettings.EMAIL_ACTION_THUNDERBIRD) {
      POCJSAPI.executeShellCommand('thunderbird -compose to="$targetEmailAddress"');
    }
  }

  @override
  void startPhoneCallImpl(final String targetPhoneNumber) {
    final int callActionId = MainController.get()!.model.settings.appSettings!.callActionId;
    if (callActionId == AppSettings.CALL_ACTION_SYSTEM_DEFAULT) {
      _startPhoneWithSystemDefault(targetPhoneNumber);
    } else if (callActionId == AppSettings.CALL_ACTION_LINPHONE) {
      POCJSAPI.executeShellCommand('linphone -c $targetPhoneNumber');
    }
  }

  @override
  void startSMSImpl(final String targetPhoneNumber) {
    //This action is not supported on the web
  }
}
