import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'package:po_contacts_flutter/view/misc/contacts_list.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/view/misc/highlighted_text.dart';

class ContactsSearchDelegate extends SearchDelegate<Contact> {
  bool searchOpen = false;

  @override
  void close(BuildContext context, Contact result) {
    if (!searchOpen) {
      // If the close function is called when the search is already closed
      // it will cause some error, preventing the error here by tracking
      // whether the search is open or not
      return;
    }
    searchOpen = false;
    super.close(context, result);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    searchOpen = true;
    final String searchText = Utils.normalizeString(query.toLowerCase());
    final List<Contact> allContacts = MainController.get().model.contactsList;
    final List<Contact> filteredContacts = [];
    final Map<int, HighlightedText> highlightedTexts = {};
    for (final Contact c in allContacts) {
      final String matchingText = matchesNormalizedSearchText(c, searchText);
      if (matchingText != null) {
        filteredContacts.add(c);
        if (searchText.trim().isNotEmpty) {
          highlightedTexts[c.id] = HighlightedText(matchingText, searchText);
        }
      }
    }
    return ContactsList(
      filteredContacts,
      I18n.string.search_list_empty_placeholder_text,
      highlightedTexts: highlightedTexts,
    );
  }

  static String matchesNormalizedSearchText(final Contact contact, final String searchText) {
    if (Utils.normalizeString(contact.fullName).contains(searchText)) return contact.fullName;
    if (Utils.normalizeString(contact.firstName).contains(searchText)) return contact.firstName;
    if (Utils.normalizeString(contact.lastName).contains(searchText)) return contact.lastName;
    if (Utils.normalizeString(contact.nickName).contains(searchText)) return contact.nickName;
    for (final StringLabeledField phoneInfo in contact.phoneInfos) {
      final String phone = phoneInfo.fieldValue;
      if (Utils.normalizeString(phone).contains(searchText)) return phone;
    }
    for (final StringLabeledField emailInfo in contact.emailInfos) {
      final String email = emailInfo.fieldValue;
      if (Utils.normalizeString(email).contains(searchText)) return email;
    }
    for (final AddressLabeledField addressLF in contact.addressInfos) {
      final AddressInfo address = addressLF.fieldValue;
      if (Utils.normalizeString(address.streetAddress).contains(searchText)) return address.streetAddress;
      if (Utils.normalizeString(address.locality).contains(searchText)) return address.locality;
      if (Utils.normalizeString(address.region).contains(searchText)) return address.region;
      if (Utils.normalizeString(address.postalCode).contains(searchText)) return address.postalCode;
      if (Utils.normalizeString(address.country).contains(searchText)) return address.country;
    }
    if (Utils.normalizeString(contact.organizationName).contains(searchText)) return contact.organizationName;
    if (Utils.normalizeString(contact.organizationDivision).contains(searchText)) return contact.organizationDivision;
    if (Utils.normalizeString(contact.organizationTitle).contains(searchText)) return contact.organizationTitle;
    if (Utils.normalizeString(contact.website).contains(searchText)) return contact.website;
    if (Utils.normalizeString(contact.notes).contains(searchText)) return contact.notes;
    return null;
  }
}
