//ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';

import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';

class ContactsStorageManagerWeb implements ContactsStorageManager {
  static const String STORAGE_KEY_INDEX = 'contactsIndex';
  static const String STORAGE_KEY_CONTACT_PREFIX = 'contacts-';

  static List<dynamic>? _readContactIdsFromStorage(final Window htmlWindow) {
    final String? storageIndexString = htmlWindow.localStorage[STORAGE_KEY_INDEX];
    if (storageIndexString == null) {
      return <dynamic>[];
    }
    return jsonDecode(storageIndexString);
  }

  static void _writeContactIdsToStorage(final Window htmlWindow, final Set<int> contactIds) {
    final List<int> contactIdsList = [];
    contactIdsList.addAll(contactIds);
    htmlWindow.localStorage[STORAGE_KEY_INDEX] = jsonEncode(contactIdsList);
  }

  static String? _readContactFromStorage(final Window htmlWindow, final int contactId) {
    final String contactStorageKey = STORAGE_KEY_CONTACT_PREFIX + '$contactId';
    return htmlWindow.localStorage[contactStorageKey];
  }

  static void _writeContactToStorage(final Window htmlWindow, final int contactId, final String? json) {
    final String contactStorageKey = STORAGE_KEY_CONTACT_PREFIX + '$contactId';
    if (json == null) {
      htmlWindow.localStorage.remove(contactStorageKey);
    } else {
      htmlWindow.localStorage[contactStorageKey] = json;
    }
  }

  int _highestKnownId = 0;
  Set<int>? _contactIds;
  late Window _htmlWindow;

  ContactsStorageManagerWeb() {
    _htmlWindow = window;
  }

  Set<int>? _getContactIds() {
    if (_contactIds != null) {
      return _contactIds;
    }
    final List<dynamic> readContactIds = _readContactIdsFromStorage(_htmlWindow)!;
    _contactIds = Set();
    for (final dynamic contactId in readContactIds) {
      if (!(contactId is int)) {
        continue;
      }
      if (contactId > _highestKnownId) {
        _highestKnownId = contactId;
      }
      _contactIds!.add(contactId);
    }
    return _contactIds;
  }

  Future<List<ContactStorageEntryWithId>> readAllContacts() async {
    final List<ContactStorageEntryWithId> res = [];
    final Set<int> contactIds = _getContactIds()!;
    for (int contactId in contactIds) {
      final String? readContactJSONString = _readContactFromStorage(_htmlWindow, contactId);
      if (readContactJSONString == null) {
        continue;
      }
      res.add(ContactStorageEntryWithId(
        contactId,
        readContactJSONString,
      ));
    }
    return res;
  }

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry) async {
    final Set<int> contactIds = _getContactIds()!;
    int newContactId = _highestKnownId + 1;
    while (contactIds.contains(newContactId)) {
      newContactId++;
    }
    _writeContactToStorage(_htmlWindow, newContactId, storageEntry.json!);
    contactIds.add(newContactId);
    _writeContactIdsToStorage(_htmlWindow, contactIds);
    return ContactStorageEntryWithId(newContactId, storageEntry.json);
  }

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry) async {
    _writeContactToStorage(_htmlWindow, contactId, storageEntry.json!);
    return ContactStorageEntryWithId(contactId, storageEntry.json);
  }

  Future<bool> deleteContact(final int contactId) async {
    _writeContactToStorage(_htmlWindow, contactId, null);
    final Set<int> contactIds = _getContactIds()!;
    contactIds.remove(contactId);
    _writeContactIdsToStorage(_htmlWindow, contactIds);
    return true;
  }
}
