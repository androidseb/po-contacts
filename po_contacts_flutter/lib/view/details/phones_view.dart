import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/details/entries_group_view.dart';

class PhonesView extends EntriesGroupView {
  PhonesView(final Contact contact) : super(contact);

  @override
  String getTitleKeyString() {
    return I18n.string.phones;
  }

  @override
  List<LabeledField> getEntries(final Contact contact) {
    return contact.phoneInfos;
  }

  @override
  List<EntriesGroupAction> getEntryAvailableActions(final StringLabeledField entry) {
    final List<EntriesGroupAction> res = [];
    final String? phoneNumber = entry.fieldValue;
    res.add(EntriesGroupAction(
      Icons.content_copy,
      I18n.getString(I18n.string.copy_to_clipboard_x, phoneNumber),
      () {
        MainController.get()!.psController.actionsManager!.copyTextToClipBoard(phoneNumber);
      },
    ));
    res.add(EntriesGroupAction(
      Icons.phone,
      I18n.getString(I18n.string.call_x, phoneNumber),
      () {
        MainController.get()!.psController.actionsManager!.startPhoneCall(phoneNumber);
      },
    ));
    if (MainController.get()!.psController.basicInfoManager!.isNotDesktop) {
      res.add(EntriesGroupAction(
        Icons.message,
        I18n.getString(I18n.string.text_x, phoneNumber),
        () {
          MainController.get()!.psController.actionsManager!.startSMS(phoneNumber);
        },
      ));
    }
    return res;
  }
}
