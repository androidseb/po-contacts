import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage.mobile.dart'
    if (dart.library.io) 'package:po_contacts_flutter/model/storage/contacts_storage.web.dart';

abstract class ContactsStorage {
  factory ContactsStorage() => getInstanceImpl();

  Future<List<ContactStorageEntryWithId>> readAllContacts();

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry);

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry);

  Future<bool> deleteContact(final int contactId);
}
