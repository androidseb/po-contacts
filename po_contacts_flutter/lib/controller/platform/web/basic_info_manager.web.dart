import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/js_api.web.dart';

class BasicInfoManagerWeb extends BasicInfoManager {
  @override
  PlatformType getPlatformType() {
    final String platformName = POCJSAPI.getPlatformName();
    if (platformName == 'darwin') {
      return PlatformType.MACOS;
    } else if (platformName == 'windows') {
      return PlatformType.WINDOWS;
    } else {
      return PlatformType.LINUX;
    }
  }
}
