import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/edit/edit_contact_form.dart';

class EditContactPage extends StatefulWidget {
  final int contactId;

  EditContactPage(this.contactId, {Key key}) : super(key: key);

  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  EditContactFormController editContactFormController;

  @override
  Widget build(BuildContext context) {
    final String titleStringKey = widget.contactId == null ? I18n.string.new_contact : I18n.string.edit_contact;
    final String titleText = I18n.getString(titleStringKey);
    final Contact currentContact = MainController.get().model.getContactById(widget.contactId);
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: I18n.getString(I18n.string.save),
            onPressed: () {
              editContactFormController?.startSaveAction();
            },
          ),
        ],
      ),
      body: EditContactForm(
        currentContact,
        onControllerReady: (final EditContactFormController controller) {
          editContactFormController = controller;
        },
        onContactSaveRequested: (final ContactBuilder contactBuilder) {
          MainController.get().saveContact(context, widget.contactId, contactBuilder);
        },
      ),
    );
  }
}
