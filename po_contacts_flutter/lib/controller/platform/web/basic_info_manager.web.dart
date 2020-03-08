import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class BasicInfoManagerWeb extends BasicInfoManager {
  @override
  PlatformType getPlatformType() {
    return PlatformType.WEB;
  }
}
