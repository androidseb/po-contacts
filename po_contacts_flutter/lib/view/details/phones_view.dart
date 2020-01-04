import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/phone_info.dart';
import 'package:po_contacts_flutter/view/details/entries_group_view.dart';

class PhonesView extends EntriesGroupView<PhoneInfo> {
  PhonesView(final Contact contact) : super(contact);

  @override
  String getTitleKeyString() {
    return I18n.string.phones;
  }

  @override
  List<PhoneInfo> getEntries(final Contact contact) {
    return contact.phoneInfos;
  }

  @override
  String getEntryTitle(final PhoneInfo entry) {
    return entry.textValue;
  }

  @override
  String getEntryHint(final PhoneInfo entry) {
    if (entry.labelType == LabeledFieldLabelType.custom) {
      return entry.labelValue;
    } else {
      return I18n.getString(LabeledField.getTypeNameStringKey(entry.labelType));
    }
  }

  @override
  List<EntriesGroupAction> getEntryAvailableActions(final PhoneInfo entry) {
    final String phoneNumber = entry.textValue;
    return [
      EntriesGroupAction(
        Icons.phone,
        I18n.getString(I18n.string.call_x, phoneNumber),
        () {
          MainController.get().startPhoneCall(phoneNumber);
        },
      ),
      EntriesGroupAction(
        Icons.message,
        I18n.getString(I18n.string.text_x, phoneNumber),
        () {
          MainController.get().startSMS(phoneNumber);
        },
      ),
    ];
  }
}
