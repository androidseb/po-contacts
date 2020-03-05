import 'package:package_info/package_info.dart';

class VersionInfo {
  //TODO add back the '...' string once the package_info package is implemented on web
  //See progress here: https://github.com/flutter/flutter/projects/69#card-30399023
  String _appVersion = '1.1.0+23';

  VersionInfo() {
    PackageInfo.fromPlatform().then((final PackageInfo packageInfo) {
      _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  String get appVersion => _appVersion;
}
