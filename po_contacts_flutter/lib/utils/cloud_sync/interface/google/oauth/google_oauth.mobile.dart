import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/oauth/google_oauth_with_device_code.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/google/sync_interface_google_drive.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/sync_exception.dart';

class GoogleOAuthMobile implements GoogleOAuth {
  GoogleSignIn _createGoogleSignIn(final String clientId) {
    return GoogleSignIn(
      clientId: clientId,
      // Workaround for the bug in the google_sign_in library causing the app to crash on iOS:
      // https://github.com/flutter/flutter/issues/46532#issuecomment-575882966
      // TLDR: hostedDomain cannot be null so it must be specificed with an empty string
      hostedDomain: '',
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/drive.file',
      ],
    );
  }

  @override
  Future<String> obtainAccessToken(final SyncInterfaceForGoogleDrive gdsi, final bool allowUI) async {
    try {
      // We try if possible to use the native Google Sign-in SDK
      final GoogleSignIn googleSignIn = _createGoogleSignIn(gdsi.config.clientId);
      GoogleSignInAccount googleSignInAccount;
      if (allowUI) {
        googleSignInAccount = await googleSignIn.signIn();
      } else {
        googleSignInAccount = await googleSignIn.signInSilently(suppressErrors: false);
      }
      if (googleSignInAccount != null) {
        return (await googleSignInAccount.authHeaders)['Authorization'];
      }
    } on PlatformException catch (platformException) {
      if (platformException.code == GoogleSignIn.kSignInFailedError) {
        // Most likely the native Google Sign-in SDK is failing (e.g. Android device without Play Services).
        // So we fall back to the code-based authentication for devices
        return GoogleOAuthWithDeviceCode.authenticateWithCode(gdsi, allowUI);
      } else if (platformException.code == GoogleSignIn.kNetworkError) {
        throw SyncException(SyncExceptionType.NETWORK);
      }
    } catch (otherException) {
      // Any other exception means the sign-in basically failed
      return null;
    }

    return null;
  }
}

GoogleOAuth getInstanceImpl() => GoogleOAuthMobile();
