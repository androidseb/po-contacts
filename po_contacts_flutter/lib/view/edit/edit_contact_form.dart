import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/edit/edit_emails_form.dart';
import 'package:po_contacts_flutter/view/edit/edit_phones_form.dart';

class EditContactForm extends StatefulWidget {
  final Contact initialContact;
  final Function(EditContactFormController editContactFormController) onControllerReady;
  final Function(ContactBuilder contactBuilder) onContactSaveRequested;

  EditContactForm(this.initialContact, {Key key, this.onControllerReady, this.onContactSaveRequested})
      : super(key: key);

  @override
  _EditContactFormState createState() => _EditContactFormState();
}

class _EditContactFormState extends State<EditContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ContactBuilder _contactBuilder = ContactBuilder();
  EditContactFormController editContactFormController;

  @override
  void initState() {
    final Contact initialContact = widget.initialContact;
    if (initialContact != null) {
      _contactBuilder.setName(initialContact.name);
      _contactBuilder.setPhoneInfos(initialContact.phoneInfos);
      _contactBuilder.setEmailInfos(initialContact.emailInfos);
      _contactBuilder.setAddress(initialContact.address);
      _contactBuilder.setOrganizationName(initialContact.organizationName);
      _contactBuilder.setOrganizationTitle(initialContact.organizationTitle);
      _contactBuilder.setNotes(initialContact.notes);
    }
    editContactFormController = EditContactFormController(this, _formKey, _contactBuilder);
    widget?.onControllerReady(editContactFormController);
    super.initState();
  }

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
                initialValue: widget?.initialContact?.name,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.name),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return I18n.getString(I18n.string.field_cannot_be_empty);
                  }
                  return null;
                },
                onChanged: (nameValue) {
                  _contactBuilder.setName(nameValue);
                },
              ),
              EditPhonesForm(
                widget?.initialContact?.phoneInfos,
                onDataChanged: (updatedPhoneInfos) {
                  _contactBuilder.setPhoneInfos(updatedPhoneInfos);
                },
              ),
              EditEmailsForm(
                widget?.initialContact?.emailInfos,
                onDataChanged: (updatedEmailInfos) {
                  _contactBuilder.setEmailInfos(updatedEmailInfos);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.address,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.address),
                ),
                onChanged: (nameValue) {
                  _contactBuilder.setAddress(nameValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_name),
                ),
                onChanged: (nameValue) {
                  _contactBuilder.setOrganizationName(nameValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationTitle,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_title),
                ),
                onChanged: (nameValue) {
                  _contactBuilder.setOrganizationTitle(nameValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.notes,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.notes),
                ),
                onChanged: (nameValue) {
                  _contactBuilder.setNotes(nameValue);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    editContactFormController.startSaveAction();
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

class EditContactFormController {
  final _EditContactFormState _parentState;
  final GlobalKey<FormState> _formKey;
  final ContactBuilder _contactBuilder;

  EditContactFormController(this._parentState, this._formKey, this._contactBuilder);

  void startSaveAction() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _parentState.widget.onContactSaveRequested(_contactBuilder);
  }
}
