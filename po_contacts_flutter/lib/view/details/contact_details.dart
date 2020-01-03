import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class ContactDetails extends StatelessWidget {
  final Contact contact;

  ContactDetails({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('test'),
    );
  }
}
