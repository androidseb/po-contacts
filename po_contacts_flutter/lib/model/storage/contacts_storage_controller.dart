import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage.dart';

class ContactStorageEntry {
  final String json;

  ContactStorageEntry(this.json);
}

class ContactStorageEntryWithId extends ContactStorageEntry {
  final int id;

  ContactStorageEntryWithId(this.id, json) : super(json);
}

class ContactsStorageController {
  final ContactsStorage _contactsStorage = ContactsStorage();
  bool storageInitStarted = false;
  bool storageInitialized = false;

  bool get isInitialized => storageInitialized;

  void initializeStorage(final Function(List<Contact> loadedContacts) callback) {
    if (storageInitStarted) {
      return;
    }
    storageInitStarted = true;
    _contactsStorage.readAllContacts().then((final List<ContactStorageEntryWithId> rawContacts) {
      final List<Contact> res = [];
      for (final ContactStorageEntryWithId c in rawContacts) {
        res.add(ContactBuilder.buildFromJson(c.id, c.json));
      }
      callback(res);
      storageInitialized = true;
    });
  }

  void createContact(final ContactBuilder contactBuilder, final Function(Contact createdContact) callback) {
    final ContactStorageEntry cse = ContactStorageEntry(ContactBuilder.toJsonString(contactBuilder));
    _contactsStorage.createContact(cse).then((final ContactStorageEntryWithId csewId) {
      final Contact createdContact = contactBuilder.build(csewId.id);
      callback(createdContact);
    });
  }

  void deleteContact(int contactId, Function(bool deleteSuccessful) callback) {
    _contactsStorage.deleteContact(contactId).then((deleteSuccessful) {
      callback(deleteSuccessful);
    });
  }

  void updateContact(
    final int contactId,
    final ContactBuilder contactBuilder,
    final Function(Contact updatedContact) callback,
  ) {
    final ContactStorageEntry cse = ContactStorageEntry(ContactBuilder.toJsonString(contactBuilder));
    _contactsStorage.updateContact(contactId, cse).then((final ContactStorageEntryWithId csewId) {
      final Contact updatedContact = contactBuilder.build(csewId.id);
      callback(updatedContact);
    });
  }
}
