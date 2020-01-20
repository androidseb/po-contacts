import 'dart:io';

import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/edit/edit_addresses_form.dart';
import 'package:po_contacts_flutter/view/edit/edit_emails_form.dart';
import 'package:po_contacts_flutter/view/edit/edit_phones_form.dart';
import 'package:po_contacts_flutter/view/misc/contact_picture.dart';

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
  String _currentImage;
  String _currentFirstName = '';
  String _currentLastName = '';
  EditContactFormController editContactFormController;

  @override
  void initState() {
    final Contact initialContact = widget.initialContact;
    if (initialContact != null) {
      _currentImage = initialContact.image;
      _contactBuilder.setFullName(initialContact.fullName);
      _currentFirstName = initialContact.firstName;
      _contactBuilder.setFirstName(_currentFirstName);
      _currentLastName = initialContact.lastName;
      _contactBuilder.setLastName(_currentLastName);
      _contactBuilder.setNickName(initialContact.nickName);
      _contactBuilder.setPhoneInfos(initialContact.phoneInfos);
      _contactBuilder.setEmailInfos(initialContact.emailInfos);
      _contactBuilder.setAddressInfos(initialContact.addressInfos);
      _contactBuilder.setOrganizationName(initialContact.organizationName);
      _contactBuilder.setOrganizationDivision(initialContact.organizationDivision);
      _contactBuilder.setOrganizationTitle(initialContact.organizationTitle);
      _contactBuilder.setWebsite(initialContact.website);
      _contactBuilder.setNotes(initialContact.notes);
    }
    editContactFormController = EditContactFormController(this, _formKey, _contactBuilder);
    widget?.onControllerReady(editContactFormController);
    super.initState();
  }

  void autoFillFullName(final TextEditingController fullNameTextController) {
    if (fullNameTextController == null) {
      return;
    }
    final String updatedFullName = (_currentFirstName + ' ' + _currentLastName).trim();
    fullNameTextController.text = updatedFullName;
    _contactBuilder.setFullName(updatedFullName);
  }

  void _onChangeImageButtonClicked() async {
    final File selectedImageFile = await MainController.get().pickImage();
    if (selectedImageFile == null) {
      return;
    }
    setState(() {
      _currentImage = selectedImageFile.path;
      _contactBuilder.setImage(_currentImage);
    });
  }

  void _onDeleteImageButtonClicked() async {
    setState(() {
      _currentImage = null;
      _contactBuilder.setImage(_currentImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameTextController;
    if (widget.initialContact == null) {
      fullNameTextController = TextEditingController();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ContactPicture(_currentImage),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FlatButton(
                            child: Text(I18n.getString(I18n.string.change_image)),
                            onPressed: () {
                              _onChangeImageButtonClicked();
                            },
                          ),
                          FlatButton(
                            child: Text(I18n.getString(I18n.string.delete_image)),
                            onPressed: () {
                              _onDeleteImageButtonClicked();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              TextFormField(
                initialValue: widget?.initialContact?.firstName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.first_name),
                ),
                onChanged: (textValue) {
                  _currentFirstName = textValue.trim();
                  _contactBuilder.setFirstName(_currentFirstName);
                  autoFillFullName(fullNameTextController);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.lastName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.last_name),
                ),
                onChanged: (textValue) {
                  _currentLastName = textValue.trim();
                  _contactBuilder.setLastName(_currentLastName);
                  autoFillFullName(fullNameTextController);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.fullName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.full_name),
                ),
                controller: fullNameTextController,
                validator: (textValue) {
                  if (textValue.trim().isEmpty) {
                    return I18n.getString(I18n.string.field_cannot_be_empty);
                  }
                  return null;
                },
                onChanged: (textValue) {
                  _contactBuilder.setFullName(textValue.trim());
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.nickName,
                textCapitalization: TextCapitalization.words,
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
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_name),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setOrganizationName(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationDivision,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_division),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setOrganizationDivision(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.organizationTitle,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.organization_title),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setOrganizationTitle(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.website,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  labelText: I18n.getString(I18n.string.website),
                ),
                onChanged: (textValue) {
                  _contactBuilder.setWebsite(textValue);
                },
              ),
              TextFormField(
                initialValue: widget?.initialContact?.notes,
                textCapitalization: TextCapitalization.sentences,
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
