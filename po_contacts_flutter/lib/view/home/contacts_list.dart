import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/home/contact_row.dart';

class ContactsList extends StatefulWidget {
  ContactsList({Key key}) : super(key: key);
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
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
    if (_contactsList.length == 0) {
      return buildIfEmpty(context);
    } else {
      return buildIfNonEmpty(context);
    }
  }

  Widget buildIfEmpty(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            I18n.getString(I18n.string.home_list_empty_placeholder_text),
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIfNonEmpty(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        itemCount: _contactsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ContactsRow(_contactsList[index]);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
