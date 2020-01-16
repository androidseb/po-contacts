import 'dart:async';

import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/details/addresses_view.dart';
import 'package:po_contacts_flutter/view/details/emails_view.dart';
import 'package:po_contacts_flutter/view/details/phones_view.dart';
import 'package:po_contacts_flutter/view/details/titled_details_text_block.dart';

class ContactDetails extends StatefulWidget {
  final int contactId;

  ContactDetails(this.contactId, {Key key}) : super(key: key);

  _ContactDetailsState createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  StreamSubscription<Contact> _contactChangeStreamSubscription;
  Contact _contact;

  @override
  void initState() {
    _contactChangeStreamSubscription = MainController.get().model.contactChangeStream.listen((final Contact contact) {
      if (contact.id != widget.contactId) {
        return;
      }
      setState(() {
        _contact = contact;
      });
    });
    _contact = MainController.get().model.getContactById(widget.contactId);
    super.initState();
  }

  @override
  void dispose() {
    _contactChangeStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_contact == null) {
      return SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'lib/assets/images/ic_profile.png',
                  height: 96,
                  width: 96,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SelectableText(
                _contact.fullName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.first_name),
            _contact.firstName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.last_name),
            _contact.lastName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.nickname),
            _contact.nickName,
          ),
          PhonesView(_contact),
          EmailsView(_contact),
          AddressesView(_contact),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_name),
            _contact.organizationName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_division),
            _contact.organizationDivision,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_title),
            _contact.organizationTitle,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.website),
            _contact.website,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.notes),
            _contact.notes,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
