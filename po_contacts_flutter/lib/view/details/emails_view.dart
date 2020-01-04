import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/email_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/details/entries_group_view.dart';

class EmailsView extends EntriesGroupView<EmailInfo> {
  EmailsView(final Contact contact) : super(contact);

  @override
  String getTitleKeyString() {
    return I18n.string.emails;
  }

  @override
  List<EmailInfo> getEntries(final Contact contact) {
    return contact.emailInfos;
  }

  @override
  String getEntryTitle(final EmailInfo entry) {
    return entry.textValue;
  }

  @override
  String getEntryHint(final EmailInfo entry) {
    if (entry.labelType == LabeledFieldLabelType.custom) {
      return entry.labelValue;
    } else {
      return I18n.getString(LabeledField.getTypeNameStringKey(entry.labelType));
    }
  }

  @override
  List<EntriesGroupAction> getEntryAvailableActions(final EmailInfo entry) {
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
