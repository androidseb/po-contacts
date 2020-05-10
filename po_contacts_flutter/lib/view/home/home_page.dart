import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/home/contacts_list.dart';
import 'package:po_contacts_flutter/view/home/home_page_drawer.dart';
import 'package:po_contacts_flutter/view/home/sync_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainController.get().updateBuildContext(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.getString(I18n.string.app_name)),
        actions: <Widget>[
          SyncButton(),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              MainController.get().startSearch();
            },
          ),
        ],
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
