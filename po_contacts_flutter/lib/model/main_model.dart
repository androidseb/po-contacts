import 'dart:async';

import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';
import 'package:po_contacts_flutter/model/version_info.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class MainModel {
  static int compareContacts(final Contact c1, final Contact c2) {
    if (c1 == null && c2 == null) {
      return 0;
    }
    if (c1 == null) {
      return -1;
    }
    if (c2 == null) {
      return 1;
    }
    return Utils.stringCompare(
      c1.nFullName.normalized,
      c2.nFullName.normalized,
    );
  }

  static void sortContactsList(final List<Contact> contactsList) {
    contactsList.sort(MainModel.compareContacts);
  }

  bool _storageInitialized = false;
  final VersionInfo _versionInfo = VersionInfo();
  final ContactsStorageController _storageController = ContactsStorageController();
  final List<Contact> _contactsList = [];
  final StreamController<List<Contact>> _contactsListSC = StreamController();
  final StreamController<Contact> _contactChangeSC = StreamController();

  MainModel() {
    _storageController.initializeStorage((final List<Contact> loadedContacts) {
      _contactsList.addAll(loadedContacts);
      sortContactsList(_contactsList);
      _storageInitialized = true;
      _contactsListSC.add(_contactsList);
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

  bool get storageInitialized => _storageInitialized;

  String get appVersion => _versionInfo.appVersion;

  List<Contact> get contactsList => _contactsList;

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

  Future<void> addContact(final ContactBuilder contactBuilder) async {
    if (!_storageController.isInitialized) {
      return;
    }
    final Contact createdContact = await _storageController.createContact(contactBuilder);
    if (createdContact == null) {
      return;
    }
    contactsList.add(createdContact);
    sortContactsList(contactsList);
    _contactsListSC.add(contactsList);
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
          sortContactsList(contactsList);
          break;
        }
      }
      _contactsListSC.add(contactsList);
      _contactChangeSC.add(updatedContact);
    });
  }
}
