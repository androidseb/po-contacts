import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';

class BasicInfoManagerWeb extends BasicInfoManager {
  @override
  PlatformType getPlatformType() {
    return PlatformType.WEB;
  }
}
