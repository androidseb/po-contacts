import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/interface/sync_interface.dart';

void main() {
  test('SyncInterfaceType enum has proper index values', () async {
    for (final SyncInterfaceType v in SyncInterfaceType.values) {
      switch (v) {
        case SyncInterfaceType.GOOGLE_DRIVE:
          expect(v, 0);
          break;
      }
    }
  });
}
