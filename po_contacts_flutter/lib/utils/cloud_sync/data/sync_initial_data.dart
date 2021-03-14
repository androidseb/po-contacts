import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

class SyncInitialData<T> {
  final FileEntity? candidateSyncFile;
  final List<T> localItems;
  final List<T> lastSyncedItems;
  final List<T> remoteItems;
  final bool hasRemoteDataFile;
  final String? remoteFileETag;

  SyncInitialData(
    this.candidateSyncFile,
    this.localItems,
    this.lastSyncedItems,
    this.remoteItems,
    this.hasRemoteDataFile,
    this.remoteFileETag,
  );
}
