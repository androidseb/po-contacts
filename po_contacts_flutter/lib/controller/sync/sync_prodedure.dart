import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/sync/sync_interface.dart';
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

  Future<SyncInitialData> _initializeSync() async {
    final List<Contact> localContacts = [];
    localContacts.addAll(MainController.get().model.contactsList);
    //TODO
    final List<Contact> lastSyncedContacts = [];
    //TODO
    final List<Contact> remoteContacts = [];
    //TODO
    return SyncInitialData(
      localContacts,
      lastSyncedContacts,
      remoteContacts,
      null,
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
