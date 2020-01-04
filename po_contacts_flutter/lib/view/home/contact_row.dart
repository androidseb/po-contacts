import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/po_constants.dart';

class ContactsRow extends StatelessWidget {
  final Contact contact;
  ContactsRow(this.contact, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: POConstants.LIST_ITEM_DEFAULT_HEIGHT,
      child: ListTile(
        title: Text(
          '${contact.name}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        leading: ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: Image.asset(
            'lib/assets/images/ic_profile.png',
            height: 32,
            width: 32,
          ),
        ),
        onTap: () {
          MainController.get().startViewContact(context, contact.id);
        },
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          iconSize: 24,
          onPressed: () {
            MainController.get().showContactQuickActionsMenu(context, contact);
          },
        ),
      ),
    );
  }
}
