// TODO draggable_scrollbar
//import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/app_settings.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/home/contact_row.dart';
import 'package:po_contacts_flutter/view/misc/highlighted_text.dart';
import 'package:po_contacts_flutter/view/misc/list_items_divider.dart';

class ContactsList extends StatefulWidget {
  final List<Contact?> _contactsList;
  final Map<int, HighlightedText>? highlightedTexts;
  final String _emptyStateStringKey;
  ContactsList(this._contactsList, this._emptyStateStringKey, {this.highlightedTexts, Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return StreamedWidget<AppSettings>(MainController.get()!.model.settings.appSettingsSV,
        (final BuildContext context, final AppSettings appSettings) {
      if (widget._contactsList.length == 0) {
        return _buildIfEmpty(context);
      } else if (appSettings != null && appSettings.displayDraggableScrollbar!) {
        return _buildIfNonEmptyWithSB(context);
      } else {
        return _buildIfNonEmptyWithoutSB(context);
      }
    });
  }

  Widget _buildIfEmpty(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            I18n.getString(widget._emptyStateStringKey),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLVIfNonEmpty(final BuildContext context, final ScrollController? scrollController) {
    //Unfortunately ListView.separated doesn't allow for a clean way to have a separator at the end of the list
    //Therefore, using ListView.builder here and manually adding the separator to the bottom of each row
    return ListView.builder(
      controller: scrollController,
      itemCount: widget._contactsList.length,
      itemBuilder: (BuildContext context, int index) {
        final Contact? contact = widget._contactsList[index];
        final HighlightedText? highlightedText =
            widget.highlightedTexts == null ? null : widget.highlightedTexts![contact!.id];
        return Column(
          children: [
            ContactsRow(contact, highlightedText: highlightedText),
            ListItemsDivider(),
          ],
        );
      },
    );
  }

  Widget _buildIfNonEmptyWithoutSB(final BuildContext context) {
    return Scrollbar(
      child: _buildLVIfNonEmpty(context, null),
    );
  }

  Widget _buildIfNonEmptyWithSB(final BuildContext context) {
    return _buildIfNonEmptyWithoutSB(context);
    // TODO draggable_scrollbar
    //final ScrollController sharedScrollScrollController = ScrollController();
    //return DraggableScrollbar.rrect(
    //  controller: sharedScrollScrollController,
    //  alwaysVisibleScrollThumb: true,
    //  heightScrollThumb: 80,
    //  backgroundColor: Colors.green[300],
    //  child: _buildLVIfNonEmpty(context, sharedScrollScrollController),
    //);
  }
}
