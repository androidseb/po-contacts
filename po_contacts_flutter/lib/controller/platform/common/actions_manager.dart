enum PlatformType { ANDROID, IOS, WEB }

abstract class ActionsManager {
  void startEmail(final String targetEmailAddress);
  void startPhoneCall(final String targetPhoneNumber);
  void startSMS(final String targetPhoneNumber);
}
