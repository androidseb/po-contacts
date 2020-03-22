import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/app_version.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptionsList = [];
    if (MainController.get().psController.basicInfoManager.isDesktop) {
      drawerOptionsList.add(ListTile(
        leading: Icon(Icons.file_download),
        title: Text(I18n.getString(I18n.string.import_vcf_file)),
        onTap: () {
          MainController.get().startImportVCFFileForWeb();
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
      leading: Icon(Icons.settings),
      title: Text(I18n.getString(I18n.string.settings)),
      onTap: () {
        MainController.get().openSettingsPage();
      },
    ));
    drawerOptionsList.add(ListTile(
      leading: Icon(Icons.info_outline),
      title: Text(I18n.getString(I18n.string.about, PO_APP_VERSION)),
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
