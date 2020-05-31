import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/utils/cloud_sync/data/sync_initial_data.dart';

class SyncResultData<T> {
  final SyncInitialData<T> initialData;
  final List<T> syncResultData;
  final bool hasLocalChanges;
  final bool hasRemoteChanges;

  SyncResultData({
    @required this.initialData,
    @required this.syncResultData,
    this.hasLocalChanges = false,
    this.hasRemoteChanges = false,
  });
}
