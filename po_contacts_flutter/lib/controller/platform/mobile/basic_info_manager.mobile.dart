import 'dart:io';

import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';

class BasicInfoManagerMobile extends BasicInfoManager {
  @override
  PlatformType getPlatformType() {
    if (Platform.isAndroid) {
      return PlatformType.ANDROID;
    } else {
      return PlatformType.IOS;
    }
  }
}
