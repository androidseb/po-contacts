import 'package:package_info/package_info.dart';

class VersionInfo {
  String _appVersion = '...';

  VersionInfo() {
    PackageInfo.fromPlatform().then((final PackageInfo packageInfo) {
      _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    });
  }

  String get appVersion => _appVersion;
}
