import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/details/addresses_view.dart';
import 'package:po_contacts_flutter/view/details/emails_view.dart';
import 'package:po_contacts_flutter/view/details/phones_view.dart';
import 'package:po_contacts_flutter/view/details/titled_details_text_block.dart';
import 'package:po_contacts_flutter/view/misc/contact_picture.dart';

class ContactDetails extends StatelessWidget {
  final int contactId;

  ContactDetails(this.contactId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamedWidget<List<Contact>>(MainController.get().model.contactsListSV,
        (final BuildContext context, final List<Contact> contacts) {
      final Contact contact = MainController.get().model.getContactById(contactId);
      return buildWithContact(context, contact);
    });
  }

  Widget buildWithContact(final BuildContext context, final Contact contact) {
    if (contact == null) {
      return SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ContactPicture(contact.image),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SelectableText(
                contact.fullName,
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
            contact.firstName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.last_name),
            contact.lastName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.nickname),
            contact.nickName,
          ),
          PhonesView(contact),
          EmailsView(contact),
          AddressesView(contact),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_name),
            contact.organizationName,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_division),
            contact.organizationDivision,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.organization_title),
            contact.organizationTitle,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.website),
            contact.website,
          ),
          TitledDetailsTextBlock(
            I18n.getString(I18n.string.notes),
            contact.notes,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
