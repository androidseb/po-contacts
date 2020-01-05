import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/details/entries_group_view.dart';

class EmailsView extends EntriesGroupView {
  EmailsView(final Contact contact) : super(contact);

  @override
  String getTitleKeyString() {
    return I18n.string.emails;
  }

  @override
  List<LabeledField> getEntries(final Contact contact) {
    return contact.emailInfos;
  }

  @override
  List<EntriesGroupAction> getEntryAvailableActions(final LabeledField entry) {
    final String emailAddress = entry.textValue;
    return [
      EntriesGroupAction(
        Icons.email,
        I18n.getString(I18n.string.email_x, emailAddress),
        () {
          MainController.get().startEmail(emailAddress);
        },
      )
    ];
  }
}
