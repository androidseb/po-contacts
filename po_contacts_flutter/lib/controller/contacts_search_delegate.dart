import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'package:po_contacts_flutter/view/misc/contacts_list.dart';

class ContactsSearchDelegate extends SearchDelegate<Contact> {
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
    final String searchText = Utils.normalizeString(query.toLowerCase());
    final List<Contact> allContacts = MainController.get().model.contactsList;
    final List<Contact> filteredContacts = [];
    for (final Contact c in allContacts) {
      if (Utils.normalizeString(c.name).contains(searchText)) {
        filteredContacts.add(c);
      }
    }
    return ContactsList(filteredContacts, I18n.string.search_list_empty_placeholder_text);
  }
}
