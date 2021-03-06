import 'dart:async';

import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class ContactStorageEntry {
  final String json;

  ContactStorageEntry(this.json);
}

class ContactStorageEntryWithId extends ContactStorageEntry {
  final int id;

  ContactStorageEntryWithId(this.id, final String json) : super(json);
}

class ContactsStorageController {
  //Internal field to store contacts storage, do not use directly
  //Use the _getContactsStorage instead
  @deprecated
  ContactsStorageManager _contactsStorage;
  final Completer<ContactsStorageManager> _contactsStorageCompleter = Completer();

  Future<ContactsStorageManager> _getContactsStorage() async {
    //ignore: deprecated_member_use_from_same_package
    if (_contactsStorage == null) {
      //ignore: deprecated_member_use_from_same_package
      _contactsStorage = await _contactsStorageCompleter.future;
    }
    //ignore: deprecated_member_use_from_same_package
    return _contactsStorage;
  }

  void initializeStorage(final ContactsStorageManager contactsStorage) {
    _contactsStorageCompleter.complete(contactsStorage);
  }

  Future<List<Contact>> readAllContacts() async {
    final ContactsStorageManager cs = await _getContactsStorage();
    final List<ContactStorageEntryWithId> rawContacts = await (cs).readAllContacts();
    final List<Contact> res = [];
    for (final ContactStorageEntryWithId c in rawContacts) {
      res.add(ContactBuilder.buildFromJson(c.id, c.json));
    }
    return res;
  }

  Future<Contact> createContact(final ContactData contactData) async {
    final ContactStorageEntry cse = ContactStorageEntry(ContactData.toJsonString(contactData));
    final ContactsStorageManager cs = await _getContactsStorage();
    final ContactStorageEntryWithId csewId = await cs.createContact(cse);
    final Contact createdContact = ContactBuilder.build(csewId.id, contactData);
    return createdContact;
  }

  Future<bool> deleteContact(int contactId) async {
    final ContactsStorageManager cs = await _getContactsStorage();
    return cs.deleteContact(contactId);
  }

  Future<Contact> updateContact(
    final int contactId,
    final ContactData contactData,
  ) async {
    final ContactsStorageManager cs = await _getContactsStorage();
    final ContactStorageEntry cse = ContactStorageEntry(ContactData.toJsonString(contactData));
    final ContactStorageEntryWithId csewId = await cs.updateContact(contactId, cse);
    final Contact updatedContact = ContactBuilder.build(csewId.id, contactData);
    return updatedContact;
  }
}
