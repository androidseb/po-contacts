import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/constants/app_version.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/home/sync_details/sync_summary.dart';

class HomePageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptionsList = [];
    drawerOptionsList.add(SyncSummary());
    drawerOptionsList.add(ListTile(
      leading: Icon(Icons.file_download),
      title: Text(I18n.getString(I18n.string.import_vcf_file)),
      onTap: () {
        MainController.get().startImportVCF();
      },
    ));
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
      title: Text(I18n.getString(I18n.string.about, POC_APP_VERSION)),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationIcon: Image.asset(
            'lib/assets/images/app_icon.png',
            width: 32,
            height: 32,
          ),
          applicationName: I18n.getString(I18n.string.app_name),
          applicationVersion: POC_APP_VERSION,
          children: <Widget>[Text(I18n.getString(I18n.string.about_message))],
        );
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
