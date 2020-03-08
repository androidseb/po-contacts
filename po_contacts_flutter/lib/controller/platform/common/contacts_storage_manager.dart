import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';

abstract class ContactsStorageManager {
  Future<List<ContactStorageEntryWithId>> readAllContacts();

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry);

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry);

  Future<bool> deleteContact(final int contactId);
}
