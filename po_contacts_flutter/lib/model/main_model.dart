import 'dart:async';

import 'package:po_contacts_flutter/model/data/contact.dart';

class MainModel {
  final List<Contact> contactsList = [];
  final StreamController<List<Contact>> _contactsListSC = new StreamController();

  Stream<List<Contact>> get contactsListStream => _contactsListSC.stream;

  Contact getContactById(final int contactId) {
    if (contactId == null) {
      return null;
    }
    for (Contact c in contactsList) {
      if (c.id == contactId) {
        return c;
      }
    }
    return null;
  }

  void addContact(final ContactBuilder contactBuilder) {
    //TODO data persistence
    contactBuilder.setId(contactsList.length + 1);
    final Contact newContact = contactBuilder.build();
    if (newContact == null) {
      return;
    }
    contactsList.add(newContact);
    _contactsListSC.add(contactsList);
  }

  void deleteContact(final int contactId) {
    //TODO data persistence
    for (int i = 0; i < contactsList.length; i++) {
      final Contact contact = contactsList[i];
      if (contact.id == contactId) {
        contactsList.removeAt(i);
      }
    }
    _contactsListSC.add(contactsList);
  }

  void overwriteContact(final int contactId, final ContactBuilder contactBuilder) {
    //TODO data persistence
    contactBuilder.setId(contactId);
    final Contact newContact = contactBuilder.build();
    if (newContact == null) {
      return;
    }
    for (int i = 0; i < contactsList.length; i++) {
      final Contact contact = contactsList[i];
      if (contact.id == contactId) {
        contactsList.removeAt(i);
        contactsList.insert(i, newContact);
        break;
      }
    }
    _contactsListSC.add(contactsList);
  }
}
