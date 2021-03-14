import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/details/contact_details.dart';

class ViewContactPage extends StatelessWidget {
  final int contactId;

  ViewContactPage(this.contactId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.getString(I18n.string.contact_details)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: I18n.getString(I18n.string.delete_contact),
            onPressed: () {
              MainController.get()!.startDeleteContact(contactId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: I18n.getString(I18n.string.edit_contact),
            onPressed: () {
              MainController.get()!.startEditContact(contactId);
            },
          ),
        ],
      ),
      body: ContactDetails(contactId),
    );
  }
}
