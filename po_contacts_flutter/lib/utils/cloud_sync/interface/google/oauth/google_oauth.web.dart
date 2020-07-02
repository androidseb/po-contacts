import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth_with_device_code.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/sync_interface_google_drive.dart';

class GoogleOAuthWeb implements GoogleOAuth {
  @override
  Future<String> obtainAccessToken(final SyncInterfaceForGoogleDrive gdsi, final bool allowUI) {
    return GoogleOAuthWithDeviceCode.authenticateWithCode(gdsi, allowUI);
  }

  @override
  Future<void> logout(final SyncInterfaceForGoogleDrive gdsi) {
    return GoogleOAuthWithDeviceCode.logout();
  }
}

GoogleOAuth getInstanceImpl() => GoogleOAuthWeb();
