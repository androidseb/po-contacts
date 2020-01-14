import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/po_constants.dart';
import 'package:po_contacts_flutter/view/misc/highlighted_text.dart';

class ContactsRow extends StatelessWidget {
  final Contact contact;
  final HighlightedText highlightedText;
  ContactsRow(this.contact, {this.highlightedText, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int maxLines = highlightedText == null ? 2 : 1;
    final double fontSize = highlightedText == null ? 18.0 : 14.0;
    final List<Widget> titleChildren = [
      Text(
        '${contact.fullName}',
        maxLines: maxLines,
        style: TextStyle(
          fontSize: fontSize,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ];
    if (highlightedText != null) {
      titleChildren.add(highlightedText);
    }
    return Container(
      height: POConstants.LIST_ITEM_DEFAULT_HEIGHT,
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: titleChildren,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'lib/assets/images/ic_profile.png',
            height: 32,
            width: 32,
          ),
        ),
        onTap: () {
          MainController.get().startViewContact(contact.id);
        },
        trailing: IconButton(
          tooltip: I18n.getString(I18n.string.quick_actions),
          icon: Icon(Icons.more_vert),
          iconSize: 24,
          onPressed: () {
            MainController.get().showContactQuickActionsMenu(contact);
          },
        ),
      ),
    );
  }
}
