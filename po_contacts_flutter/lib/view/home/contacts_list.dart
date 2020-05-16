import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/misc/contacts_list.dart';

class AllContactsList extends StatelessWidget {
  AllContactsList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamedWidget<List<Contact>>(MainController.get().model.contactsListSV,
        (final BuildContext context, final List<Contact> contacts) {
      return buildWithContacts(context, contacts);
    });
  }

  Widget buildWithContacts(final BuildContext context, final List<Contact> contactsList) {
    if (MainController.get().model.storageInitialized) {
      return ContactsList(contactsList, I18n.string.home_list_empty_placeholder_text);
    } else {
      return ContactsList(contactsList, I18n.string.loading);
    }
  }
}
