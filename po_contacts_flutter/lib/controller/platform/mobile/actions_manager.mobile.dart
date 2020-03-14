import 'package:url_launcher/url_launcher.dart';

import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';

class ActionsManagerMobile extends ActionsManager {
  @override
  void startEmail(final String targetPhoneNumbers) {
    launch('mailto:$targetPhoneNumbers');
  }

  @override
  void startPhoneCall(final String targetPhoneNumber) {
    launch('tel:$targetPhoneNumber');
  }

  @override
  void startSMS(final String targetPhoneNumber) {
    launch('sms:$targetPhoneNumber');
  }
}
