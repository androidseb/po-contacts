import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/view/home/contact_row.dart';
import 'package:po_contacts_flutter/view/misc/highlighted_text.dart';
import 'package:po_contacts_flutter/view/misc/list_items_divider.dart';

class ContactsList extends StatelessWidget {
  final List<Contact> _contactsList;
  final Map<int, HighlightedText> highlightedTexts;
  final String _emptyStateStringKey;
  ContactsList(this._contactsList, this._emptyStateStringKey, {this.highlightedTexts, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_contactsList.length == 0) {
      return _buildIfEmpty(context);
    } else if (MainController.get().psController.basicInfoManager.isWeb) {
      return _buildIfNonEmptyWeb(context);
    } else {
      return _buildIfNonEmpty(context);
    }
  }

  Widget _buildIfEmpty(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            I18n.getString(_emptyStateStringKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLVIfNonEmpty(final BuildContext context, final ScrollController scrollController) {
    //Unfortunately ListView.separated doesn't allow for a clean way to have a separator at the end of the list
    //Therefore, using ListView.builder here and manually adding the separator to the bottom of each row
    return ListView.builder(
      controller: scrollController,
      itemCount: _contactsList.length,
      itemBuilder: (BuildContext context, int index) {
        final Contact contact = _contactsList[index];
        final HighlightedText highlightedText = highlightedTexts == null ? null : highlightedTexts[contact.id];
        return Column(
          children: [
            ContactsRow(contact, highlightedText: highlightedText),
            ListItemsDivider(),
          ],
        );
      },
    );
  }

  Widget _buildIfNonEmpty(final BuildContext context) {
    return Scrollbar(
      child: _buildLVIfNonEmpty(context, null),
    );
  }

  Widget _buildIfNonEmptyWeb(final BuildContext context) {
    final ScrollController sharedScrollScrollController = ScrollController();
    return DraggableScrollbar.rrect(
      controller: sharedScrollScrollController,
      alwaysVisibleScrollThumb: true,
      heightScrollThumb: 80,
      backgroundColor: Colors.green[300],
      child: _buildLVIfNonEmpty(context, sharedScrollScrollController),
    );
  }
}
