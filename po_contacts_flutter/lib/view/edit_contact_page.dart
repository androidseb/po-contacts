import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';

class EditContactPage extends StatelessWidget {
  final int contactId;
  EditContactPage({Key key, this.contactId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String titleText = I18n.getString(contactId == null ? I18n.string.new_contact : I18n.string.edit_contact);
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: const Center(
        child: Text(
          'TODO',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  //TODO
  //final int epochMillis = new DateTime.now().millisecondsSinceEpoch;
  //this._model.addContact(new ContactBuilder().setFirstName('First $epochMillis').setLastName('Last $epochMillis'));
}
