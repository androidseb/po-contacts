import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/po_constants.dart';

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
    return Scrollbar(
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _contactsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: POConstants.LIST_ITEM_DEFAULT_HEIGHT,
            child: ListTile(
              title: Text('${_contactsList[index].name}'),
              onTap: () {
                MainController.get().startViewContact(context, _contactsList[index].id);
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
