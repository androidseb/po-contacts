import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/utils/streamable_value.dart';
import 'package:po_contacts_flutter/view/home/contacts_list.dart';
import 'package:po_contacts_flutter/view/home/home_page_drawer.dart';
import 'package:po_contacts_flutter/view/home/sync_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainController.get().updateBuildContext(context);
    return WillPopScope(
      onWillPop: () async {
        if (MainController.get().model.selectedContactIds.isEmpty) {
          return true;
        }
        MainController.get().selectNoContacts();
        return false;
      },
      child: StreamedWidget(MainController.get().model.contactsListSV,
          (final BuildContext context, final List<Contact> contactsList) {
        return StreamedWidget(MainController.get().model.selectedContactIdsSV,
            (final BuildContext context, final Set<int> selectedContactIds) {
          final List<Widget> appBarWidgets = _buidAppBarWidgets(contactsList, selectedContactIds);
          return _buildHomePage(appBarWidgets);
        });
      }),
    );
  }

  List<Widget> _buidAppBarWidgets(final List<Contact> contactsList, final Set<int> selectedContactIds) {
    final List<Widget> res = [];
    if (selectedContactIds.isEmpty) {
      res.add(SyncButton());
    } else {
      if (selectedContactIds.length == contactsList.length) {
        res.add(IconButton(
          icon: Icon(Icons.check_box),
          onPressed: () {
            MainController.get().selectNoContacts();
          },
        ));
      } else {
        res.add(IconButton(
          icon: Icon(Icons.check_box_outline_blank),
          onPressed: () {
            MainController.get().selectAllContacts();
          },
        ));
      }
      res.add(IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          MainController.get().showContactSelectionActionsMenu();
        },
      ));
    }
    res.add(IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        MainController.get().startSearch();
      },
    ));
    return res;
  }

  Widget _buildHomePage(final List<Widget> appBarWidgets) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.getString(I18n.string.app_name)),
        actions: appBarWidgets,
      ),
      drawer: HomePageDrawer(),
      body: AllContactsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MainController.get().startAddContact();
        },
        tooltip: I18n.getString(I18n.string.create_new_contact),
        child: Icon(Icons.add),
      ),
    );
  }
}
