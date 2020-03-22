enum PlatformType { ANDROID, IOS, LINUX, MACOS, WINDOWS }

abstract class BasicInfoManager {
  PlatformType getPlatformType();

  bool _isAndroid;
  bool _isIOS;
  bool _isMobile;
  bool _isLinux;
  bool _isMacOS;
  bool _isWindows;
  bool _isDesktop;

  BasicInfoManager() {
    _isAndroid = getPlatformType() == PlatformType.ANDROID;
    _isIOS = getPlatformType() == PlatformType.IOS;
    _isMobile = _isAndroid || _isIOS;
    _isLinux = getPlatformType() == PlatformType.LINUX;
    _isMacOS = getPlatformType() == PlatformType.MACOS;
    _isWindows = getPlatformType() == PlatformType.WINDOWS;
    _isDesktop = _isLinux || _isMacOS || _isWindows;
  }

  bool get isAndroid => _isAndroid;
  bool get isIOS => _isIOS;
  bool get isMobile => _isMobile;
  bool get isLinux => _isLinux;
  bool get isMacOS => _isMacOS;
  bool get isWindows => _isWindows;
  bool get isDesktop => _isDesktop;
  bool get isNotDesktop => !isDesktop;
}
