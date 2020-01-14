import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/misc/list_section_header.dart';

class EntriesGroupAction {
  final IconData iconData;
  final String hintText;
  final Function onTap;

  EntriesGroupAction(
    this.iconData,
    this.hintText,
    this.onTap,
  );
}

abstract class EntriesGroupView extends StatelessWidget {
  final Contact _contact;

  EntriesGroupView(this._contact);

  String getTitleKeyString();

  List<LabeledField> getEntries(final Contact contact);

  List<EntriesGroupAction> getEntryAvailableActions(final StringLabeledField entry);

  String getEntryTitle(final StringLabeledField entry) {
    return entry.fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    final List<LabeledField> entries = getEntries(_contact);
    if (entries == null || entries.isEmpty) {
      return SizedBox.shrink();
    }

    final List<Widget> colChildren = [];
    colChildren.add(ListSectionHeader(I18n.getString(getTitleKeyString())));
    for (final StringLabeledField entry in entries) {
      final List<Widget> actionButtons = [];
      final List<EntriesGroupAction> actions = getEntryAvailableActions(entry);
      for (final EntriesGroupAction a in actions) {
        actionButtons.add(IconButton(
          tooltip: a.hintText,
          icon: Icon(a.iconData),
          onPressed: a.onTap,
        ));
      }
      colChildren.add(
        ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                getEntryTitle(entry),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(LabeledField.getLabelTypeDisplayText(entry)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: actionButtons,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: colChildren,
    );
  }
}
