import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:po_contacts_flutter/assets/constants/google_oauth_client_id.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';

enum SyncState {
  IDLE,
  SYNCING,
  LAST_SYNC_FAILED,
}

class SyncController {
  final StreamableValue<SyncState> _syncState = StreamableValue(SyncState.IDLE);
  SyncState get syncState => _syncState.readOnly.currentValue;
  ReadOnlyStreamableValue<SyncState> get syncStateSV => _syncState.readOnly;

  void onClickSyncButton() async {
    if (_syncState.currentValue == SyncState.SYNCING) {
      return;
    }
    _syncState.currentValue = SyncState.SYNCING;
    final bool syncSuccessful = await performSync();
    if (syncSuccessful) {
      _syncState.currentValue = SyncState.IDLE;
    } else {
      _syncState.currentValue = SyncState.LAST_SYNC_FAILED;
    }
  }

  Future<bool> performSync() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: POC_GOOGLE_OAUTH_CLIENT_ID,
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/drive.appdata',
      ],
    );
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    //final Map<String, String> authHeaders = await googleSignInAccount.authHeaders;
    MainController.get().showMessageDialog('TEST', 'SUCCESSFULLY AUTHENTICATED WITH: ${googleSignInAccount.email}');
    await Future.delayed(const Duration(milliseconds: 5000));
    return false;
  }
}
