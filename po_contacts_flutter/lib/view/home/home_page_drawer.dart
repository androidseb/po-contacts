import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptionsList = [];
    if (MainController.get().psController.basicInfoManager.isWeb) {
      drawerOptionsList.add(ListTile(
        leading: Icon(Icons.file_download),
        title: Text(I18n.getString(I18n.string.import_vcf_file)),
        onTap: () {
          //TODO open file picker and start import flow
        },
      ));
    }
    drawerOptionsList.add(ListTile(
      leading: Icon(Icons.file_upload),
      title: Text(I18n.getString(I18n.string.export_all_as_vcf)),
      onTap: () {
        MainController.get().startExportAllAsVCF();
      },
    ));
    drawerOptionsList.add(ListTile(
      leading: Icon(Icons.info_outline),
      title: Text(I18n.getString(I18n.string.about, MainController.get().model.appVersion)),
      onTap: () {
        MainController.get().showAboutDialog();
      },
    ));
    return Drawer(
      child: SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerOptionsList,
        ),
      ),
    );
  }
}
