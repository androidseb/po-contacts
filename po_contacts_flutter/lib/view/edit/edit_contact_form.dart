import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class EditContactForm extends StatefulWidget {
  final Function(ContactBuilder contactBuilder) onContactSaveRequested;

  EditContactForm({Key key, this.onContactSaveRequested}) : super(key: key);

  @override
  _EditContactFormState createState() => _EditContactFormState();
}

class _EditContactFormState extends State<EditContactForm> {
  final _formKey = GlobalKey<FormState>();
  final ContactBuilder _contactBuilder = new ContactBuilder();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.name),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return I18n.getString(I18n.string.name_cannot_be_empty);
                  }
                  return null;
                },
                onChanged: (nameValue) {
                  _contactBuilder.setName(nameValue);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    widget.onContactSaveRequested(_contactBuilder);
                  },
                  child: Text(I18n.getString(I18n.string.save)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
