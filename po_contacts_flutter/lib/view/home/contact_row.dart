import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/assets/constants/poc_constants.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/misc/contact_picture.dart';
import 'package:po_contacts_flutter/view/misc/highlighted_text.dart';

class ContactsRow extends StatelessWidget {
  final Contact contact;
  final HighlightedText highlightedText;
  ContactsRow(this.contact, {this.highlightedText, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> titleChildren = _buildTitleChildren();
    final Widget trailingWidget = _buildTrailingWidget();
    return Container(
      height: POCConstants.LIST_ITEM_DEFAULT_HEIGHT,
      child: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: titleChildren,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ContactPicture(
            contact.image,
            imageWidth: 32,
            imageHeight: 32,
          ),
        ),
        onTap: () {
          if (MainController.get().model.selectedContactIds.length == 0) {
            MainController.get().startViewContact(contact.id);
          } else {
            if (MainController.get().model.selectedContactIds.contains(contact.id)) {
              MainController.get().unselectContact(contact.id);
            } else {
              MainController.get().selectContact(contact.id);
            }
          }
        },
        onLongPress: () {
          MainController.get().selectContact(contact.id);
        },
        trailing: trailingWidget,
      ),
    );
  }

  List<Widget> _buildTitleChildren() {
    final int maxLines = highlightedText == null ? 2 : 1;
    final double fontSize = highlightedText == null ? 18.0 : 14.0;
    final List<Widget> res = [
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
      res.add(highlightedText);
    }
    return res;
  }

  Widget _buildTrailingWidget() {
    return StreamedWidget(MainController.get().model.selectedContactIdsSV,
        (final BuildContext context, final Set<int> selectedContactIds) {
      if (selectedContactIds.length == 0) {
        return _buildTrailingNoCheckbox();
      } else {
        return _buildTrailingCheckbox(selectedContactIds.contains(contact.id));
      }
    });
  }

  Widget _buildTrailingNoCheckbox() {
    return IconButton(
      tooltip: I18n.getString(I18n.string.quick_actions),
      icon: Icon(Icons.more_vert),
      iconSize: 24,
      onPressed: () {
        MainController.get().showContactQuickActionsMenu(contact);
      },
    );
  }

  Widget _buildTrailingCheckbox(final bool contactSelected) {
    return Checkbox(
      value: contactSelected,
      onChanged: (final bool value) {
        if (value) {
          MainController.get().selectContact(contact.id);
        } else {
          MainController.get().unselectContact(contact.id);
        }
      },
    );
  }
}
