import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_form.dart';

class EditContactPage extends StatelessWidget {
  final int contactId;

  EditContactPage(this.contactId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String titleStringKey = contactId == null ? I18n.string.new_contact : I18n.string.edit_contact;
    final String titleText = I18n.getString(titleStringKey);
    final Contact currentContact = MainController.get().model.getContactById(contactId);
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: EditContactForm(currentContact, onContactSaveRequested: (ContactBuilder contactBuilder) {
        MainController.get().saveContact(context, contactId, contactBuilder);
      }),
    );
  }
}
