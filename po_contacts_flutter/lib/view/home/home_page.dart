import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/home/contacts_list.dart';
import 'package:po_contacts_flutter/view/home/home_page_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.getString(I18n.string.app_name)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              MainController.get().startSearch(context);
            },
          ),
        ],
      ),
      drawer: HomePageDrawer(),
      body: AllContactsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MainController.get().startAddContact(context);
        },
        tooltip: I18n.getString(I18n.string.create_new_contact),
        child: Icon(Icons.add),
      ),
    );
  }
}
