import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/po_constants.dart';

class RootView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: I18n.getString(I18n.string.app_name),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainView(title: I18n.getString(I18n.string.app_name)),
    );
  }
}

class MainView extends StatelessWidget {
  final String title;

  MainView({Key key, this.title}) : super(key: key);

  void _onAddButtonClicked() {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    //TODO
    final List<String> contactsList = [];
    for (int i = 0; i < 100; i++) {
      contactsList.add('Contact ${i + 1}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: SafeArea(
          top: true,
          bottom: false,
          left: false,
          right: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                title: Text(I18n.getString(I18n.string.export_all_as_vcf)),
                onTap: () {
                  //TODO
                },
              ),
              ListTile(
                title: Text(I18n.getString(I18n.string.about, POConstants.APP_VERSION)),
                onTap: () {
                  MainController.showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: contactsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: POConstants.LIST_ITEM_DEFAULT_HEIGHT,
              child: Center(child: Text('${contactsList[index]}')),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonClicked,
        tooltip: I18n.getString(I18n.string.create_new_contact),
        child: Icon(Icons.add),
      ),
    );
  }
}
