import 'dart:async';

import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/settings_model.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
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
  final SettingsModel _settingsModel = SettingsModel();
  final ContactsStorageController _contactsStorageController = ContactsStorageController();
  final StreamableValue<List<Contact>> _contactsList = StreamableValue([]);

  void initializeMainModel(final ContactsStorageManager contactsStorage) async {
    _contactsStorageController.initializeStorage(contactsStorage);
    final List<Contact> loadedContacts = await _contactsStorageController.readAllContacts();
    contactsList.addAll(loadedContacts);
    sortContactsList(contactsList);
    _storageInitialized = true;
    _contactsList.notifyDataChanged();
  }

  SettingsModel get settings => _settingsModel;

  bool get storageInitialized => _storageInitialized;

  ReadOnlyStreamableValue<List<Contact>> get contactsListSV => _contactsList.readOnly;
  List<Contact> get contactsList => _contactsList.currentValue;

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

  Future<void> addContact(final ContactData contactData) async {
    final Contact createdContact = await _contactsStorageController.createContact(contactData);
    if (createdContact == null) {
      return;
    }
    contactsList.add(createdContact);
    sortContactsList(contactsList);
    _contactsList.notifyDataChanged();
  }

  void deleteContact(final int contactId) async {
    final bool deleteSuccessful = await _contactsStorageController.deleteContact(contactId);
    if (!deleteSuccessful) {
      return;
    }
    for (int i = 0; i < contactsList.length; i++) {
      final Contact contact = contactsList[i];
      if (contact.id == contactId) {
        contactsList.removeAt(i);
      }
    }
    _contactsList.notifyDataChanged();
  }

  void overwriteContact(final int contactId, final ContactData contactData) async {
    final Contact updatedContact = await _contactsStorageController.updateContact(contactId, contactData);
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
    _contactsList.notifyDataChanged();
  }

  void overwriteAllContacts(final List<Contact> contacts) async {
    // Initializing a list of new contacts
    final List<Contact> newContacts = [];

    // Creating all the new contacts into the storage
    for (final Contact c in contacts) {
      newContacts.add(await _contactsStorageController.createContact(c));
    }

    // Deleting all old contacts from storage
    for (final Contact c in contactsList) {
      await _contactsStorageController.deleteContact(c.id);
    }

    // Deleting all old contacts from memory
    contactsList.clear();

    // Adding all the new contacts into memory
    contactsList.addAll(newContacts);
    sortContactsList(contactsList);

    _contactsList.notifyDataChanged();
  }
}
