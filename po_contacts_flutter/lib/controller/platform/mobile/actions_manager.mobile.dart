import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';

class ActionsManagerMobile extends ActionsManager {
  @override
  void copyTextToClipBoard(final String? text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void startEmail(final String? targetEmailAddress) {
    launch('mailto:$targetEmailAddress');
  }

  @override
  void startPhoneCallImpl(final String targetPhoneNumber) {
    launch('tel:$targetPhoneNumber');
  }

  @override
  void startSMSImpl(final String targetPhoneNumber) {
    launch('sms:$targetPhoneNumber');
  }
}
