import 'package:flutter/foundation.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/platform_specific_controller.mobile.dart'
    if (dart.library.io) 'package:po_contacts_flutter/controller/platform/web/platform_specific_controller.web.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';

abstract class ContactsStorage {
  Future<List<ContactStorageEntryWithId>> readAllContacts();

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry);

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry);

  Future<bool> deleteContact(final int contactId);
}

abstract class FilesTransitManager {
  Future<String> getInboxFileId();

  Future<void> discardInboxFileId(final String inboxFileId);

  Future<String> getCopiedInboxFilePath(final String inboxFileId);

  Future<String> getOutputFilesDirectoryPath();

  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath);
}

abstract class PSHelper {
  factory PSHelper() => getInstanceImpl();

  @protected
  ContactsStorage createContactStorage();

  @protected
  FilesTransitManager createFilesTransitManager();
}

class PlatformSpecificController {
  final PSHelper _psHelper = PSHelper();

  ContactsStorage _contactsStorage;
  FilesTransitManager _filesTransitManager;

  ContactsStorage get contactsStorage {
    if (_contactsStorage == null) {
      _contactsStorage = _psHelper.createContactStorage();
    }
    return _contactsStorage;
  }

  FilesTransitManager get fileTransitManager {
    if (_filesTransitManager == null) {
      _filesTransitManager = _psHelper.createFilesTransitManager();
    }
    return _filesTransitManager;
  }
}
