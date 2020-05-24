import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/sync/data/remote_file.dart';
import 'package:po_contacts_flutter/controller/sync/sync_interface.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/disk_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class SyncInitialData {
  final List<Contact> localContacts;
  final List<Contact> lastSyncedContacts;
  final List<Contact> remoteContacts;
  final String remoteFileETag;

  SyncInitialData(
    this.localContacts,
    this.lastSyncedContacts,
    this.remoteContacts,
    this.remoteFileETag,
  );
}

class SyncProcedure {
  final SyncInterface syncInterface;
  bool _canceled = false;

  SyncProcedure(this.syncInterface);

  void cancel() {
    _canceled = false;
  }

  Future<List<Contact>> _fileEntityToItemsList(final FileEntity fileEntity) async {
    return [];
//TODO convert this into an abstract generic type method
/**
    lastSyncedContacts = await VCFSerializer.readFromVCF(
        VCFFileReader(
          lastSyncedFile,
          syncInterface.derivedEncryptionKey,
          DiskFileInflater(),
        ),
      );
 */
  }

  Future<SyncInitialData> _initializeSync() async {
    final List<Contact> localContacts = [];
    localContacts.addAll(MainController.get().model.contactsList);
    final RemoteFile currentIndexFile = syncInterface.selectedCloudIndexFile;
    final String fileETag = await syncInterface.getFileETag(currentIndexFile.fileId);
    final FileEntity lastSyncedFile = syncInterface.getLastSyncedFile();
    List<Contact> lastSyncedContacts = await _fileEntityToItemsList(lastSyncedFile);
    final FileEntity latestCloudFile = await syncInterface.getLatestCloudFile();
    final List<Contact> remoteContacts = await _fileEntityToItemsList(latestCloudFile);
    return SyncInitialData(
      localContacts,
      lastSyncedContacts,
      remoteContacts,
      fileETag,
    );
  }

  Future<List<Contact>> _computeSyncResult(final SyncInitialData syncInitialData) async {
    //TODO
  }

  Future<void> _finalizeSync(final List<Contact> syncResult, final String targetETag) async {
    //TODO
  }

  Future<void> execute() async {
    final SyncInitialData syncInitialData = await _initializeSync();
    final List<Contact> syncResult = await _computeSyncResult(syncInitialData);
    await _finalizeSync(syncResult, syncInitialData.remoteFileETag);
  }
}
