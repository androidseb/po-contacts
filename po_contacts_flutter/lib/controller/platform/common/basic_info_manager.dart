enum PlatformType { ANDROID, IOS, WEB }

abstract class BasicInfoManager {
  PlatformType getPlatformType();

  bool _isWeb;
  bool _isAndroid;
  bool _isIOS;
  bool _isMobile;

  BasicInfoManager() {
    _isWeb = getPlatformType() == PlatformType.WEB;
    _isAndroid = getPlatformType() == PlatformType.ANDROID;
    _isIOS = getPlatformType() == PlatformType.IOS;
    _isMobile = _isAndroid || _isIOS;
  }

  bool get isWeb {
    return _isWeb;
  }

  bool get isNotWeb {
    return !isWeb;
  }

  bool get isAndroid {
    return _isAndroid;
  }

  bool get isIOS {
    return _isIOS;
  }

  bool get isMobile {
    return _isMobile;
  }
}
