import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/home/contact_row.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> _contactsList;
  final String _emptyStateStringKey;
  ContactsList(this._contactsList, this._emptyStateStringKey, {Key key}) : super(key: key);

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
            I18n.getString(_emptyStateStringKey),
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
