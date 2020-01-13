import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/edit/edit_addresses_form.dart';
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
      _contactBuilder.setFullName(initialContact.fullName);
      _contactBuilder.setFirstName(initialContact.firstName);
      _contactBuilder.setLastName(initialContact.lastName);
      _contactBuilder.setNickName(initialContact.nickName);
      _contactBuilder.setPhoneInfos(initialContact.phoneInfos);
      _contactBuilder.setEmailInfos(initialContact.emailInfos);
      _contactBuilder.setAddressInfos(initialContact.addressInfos);
      _contactBuilder.setOrganizationName(initialContact.organizationName);
      _contactBuilder.setOrganizationTitle(initialContact.organizationTitle);
      _contactBuilder.setWebsite(initialContact.website);
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
                initialValue: widget?.initialContact?.fullName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.full_name),
                ),
                validator: (textValue) {
                  if (textValue.isEmpty) {
                    return I18n.getString(I18n.string.field_cannot_be_empty);
                  }
                  return null;
                },
                onChanged: (textValue) {
                  _contactBuilder.setFullName(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.firstName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.first_name),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setFirstName(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.lastName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.last_name),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setLastName(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.nickName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.nickname),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setNickName(textValue);
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
              EditAddressesForm(
                widget?.initialContact?.addressInfos,
                onDataChanged: (updatedAddressInfos) {
                  _contactBuilder.setAddressInfos(updatedAddressInfos);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationName,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_name),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setOrganizationName(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationTitle,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_title),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setOrganizationTitle(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.website,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.website),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setWebsite(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.notes,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.notes),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setNotes(textValue);
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
