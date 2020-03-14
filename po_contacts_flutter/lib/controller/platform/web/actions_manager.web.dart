import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/js_api.web.dart';

class ActionsManagerWeb extends ActionsManager {
  @override
  void startEmail(final String targetEmailAddress) {
    POCJSAPI.executeShellCommand('thunderbird -compose to="$targetEmailAddress"');
  }

  @override
  void startPhoneCallImpl(final String targetPhoneNumber) {
    POCJSAPI.executeShellCommand('linphone -c $targetPhoneNumber');
  }

  @override
  void startSMSImpl(final String targetPhoneNumber) {
    //This action is not supported on the web
  }
}
