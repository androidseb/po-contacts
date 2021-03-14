abstract class ActionsManager {
  static String _sanitizedPhoneNumber(final String? phoneNumber) {
    if (phoneNumber == null) {
      return '';
    }
    return phoneNumber.replaceAll(' ', '');
  }

  void copyTextToClipBoard(final String? text);

  void startEmail(final String? targetEmailAddress);

  void startPhoneCall(final String? targetPhoneNumber) {
    startPhoneCallImpl(_sanitizedPhoneNumber(targetPhoneNumber));
  }

  void startPhoneCallImpl(final String targetPhoneNumber);

  void startSMS(final String? targetPhoneNumber) {
    startSMSImpl(_sanitizedPhoneNumber(targetPhoneNumber));
  }

  void startSMSImpl(final String targetPhoneNumber);
}
