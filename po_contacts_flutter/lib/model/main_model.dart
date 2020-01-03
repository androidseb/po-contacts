import 'dart:async';

import 'package:po_contacts_flutter/model/data/contact.dart';

class MainModel {
  final List<Contact> contactsList = [];
  final StreamController<List<Contact>> _contactsListSC = new StreamController();

  Stream<List<Contact>> get contactsListStream => _contactsListSC.stream;

  void addContact(final ContactBuilder contactBuilder) {
    final Contact newContact = contactBuilder.build();
    if (newContact == null) {
      return;
    }
    contactsList.add(newContact);
    _contactsListSC.add(contactsList);
  }
}
