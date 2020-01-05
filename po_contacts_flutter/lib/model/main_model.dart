import 'dart:async';

import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';

class MainModel {
  final ContactsStorageController _storageController = ContactsStorageController();
  final List<Contact> contactsList = [];
  final StreamController<List<Contact>> _contactsListSC = StreamController();
  final StreamController<Contact> _contactChangeSC = StreamController();

  MainModel() {
    _storageController.initializeStorage((final List<Contact> loadedContacts) {
      contactsList.addAll(loadedContacts);
      _contactsListSC.add(contactsList);
    });
  }

  Stream<List<Contact>> _contactsListStream;
  Stream<List<Contact>> _getContactsListStream() {
    if (_contactsListStream == null) {
      _contactsListStream = _contactsListSC.stream.asBroadcastStream();
    }
    return _contactsListStream;
  }

  Stream<Contact> _contactChangeStream;
  Stream<Contact> _getContactChangeStream() {
    if (_contactChangeStream == null) {
      _contactChangeStream = _contactChangeSC.stream.asBroadcastStream();
    }
    return _contactChangeStream;
  }

  Stream<List<Contact>> get contactsListStream => _getContactsListStream();

  Stream<Contact> get contactChangeStream => _getContactChangeStream();

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
    if (!_storageController.isInitialized) {
      return;
    }
    _storageController.createContact(contactBuilder, (final Contact createdContact) {
      if (createdContact == null) {
        return;
      }
      contactsList.add(createdContact);
      _contactsListSC.add(contactsList);
    });
  }

  void deleteContact(final int contactId) {
    if (!_storageController.isInitialized) {
      return;
    }
    _storageController.deleteContact(contactId, (final bool deleteSuccessful) {
      if (!deleteSuccessful) {
        return;
      }
      for (int i = 0; i < contactsList.length; i++) {
        final Contact contact = contactsList[i];
        if (contact.id == contactId) {
          contactsList.removeAt(i);
        }
      }
      _contactsListSC.add(contactsList);
    });
  }

  void overwriteContact(final int contactId, final ContactBuilder contactBuilder) {
    if (!_storageController.isInitialized) {
      return;
    }
    _storageController.updateContact(contactId, contactBuilder, (final Contact updatedContact) {
      if (updatedContact == null) {
        return;
      }
      for (int i = 0; i < contactsList.length; i++) {
        final Contact contact = contactsList[i];
        if (contact.id == contactId) {
          contactsList.removeAt(i);
          contactsList.insert(i, updatedContact);
          break;
        }
      }
      _contactsListSC.add(contactsList);
      _contactChangeSC.add(updatedContact);
    });
  }
}
