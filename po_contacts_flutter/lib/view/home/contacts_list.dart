import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/misc/contacts_list.dart';

class AllContactsList extends StatefulWidget {
  AllContactsList({Key key}) : super(key: key);
  @override
  _AllContactsListState createState() => _AllContactsListState();
}

class _AllContactsListState extends State<AllContactsList> {
  StreamSubscription<List<Contact>> _contactsListStreamSubscription;
  List<Contact> _contactsList = [];

  @override
  void initState() {
    _contactsListStreamSubscription =
        MainController.get().model.contactsListStream.listen((final List<Contact> contactsList) {
      setState(() {
        _contactsList = contactsList;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _contactsListStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContactsList(_contactsList, I18n.string.home_list_empty_placeholder_text);
  }
}
