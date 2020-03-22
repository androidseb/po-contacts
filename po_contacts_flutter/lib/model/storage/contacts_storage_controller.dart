import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class ContactStorageEntry {
  final String json;

  ContactStorageEntry(this.json);
}

class ContactStorageEntryWithId extends ContactStorageEntry {
  final int id;

  ContactStorageEntryWithId(this.id, json) : super(json);
}

class ContactsStorageController {
  ContactsStorageManager _contactsStorage;
  //TODO remove this boolean and use the dart async methods with a Completer object
  bool storageInitialized = false;

  bool get isInitialized => storageInitialized;

  void initializeStorage(
      final ContactsStorageManager contactsStorage, final Function(List<Contact> loadedContacts) callback) {
    if (_contactsStorage != null) {
      return;
    }
    _contactsStorage = contactsStorage;
    _contactsStorage.readAllContacts().then((final List<ContactStorageEntryWithId> rawContacts) {
      final List<Contact> res = [];
      for (final ContactStorageEntryWithId c in rawContacts) {
        res.add(ContactBuilder.buildFromJson(c.id, c.json));
      }
      callback(res);
      storageInitialized = true;
    });
  }

  Future<Contact> createContact(final ContactBuilder contactBuilder) async {
    final ContactStorageEntry cse = ContactStorageEntry(ContactBuilder.toJsonString(contactBuilder));
    final ContactStorageEntryWithId csewId = await _contactsStorage.createContact(cse);
    final Contact createdContact = contactBuilder.build(csewId.id);
    return createdContact;
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
