import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.stub.dart'
    if (dart.library.io) 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.mobile.dart'
    if (dart.library.html) 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.web.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/sync_interface_google_drive.dart';

/// Utility class to authenticate using Google oAuth
abstract class GoogleOAuth {
  static GoogleOAuth _currentInstance;
  factory GoogleOAuth() => getInstanceImpl();

  static GoogleOAuth get instance {
    if (_currentInstance == null) {
      _currentInstance = getInstanceImpl();
    }
    return _currentInstance;
  }

  Future<String> obtainAccessToken(final SyncInterfaceForGoogleDrive gdsi, final bool allowUI);

  Future<void> logout(final SyncInterfaceForGoogleDrive gdsi);
}
