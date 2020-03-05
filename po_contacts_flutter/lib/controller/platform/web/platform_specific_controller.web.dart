import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/platform/web/contacts_storage.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/files_manager.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/files_transit_manager.web.dart';

class PSHelperWeb implements PSHelper {
  @override
  ContactsStorage createContactStorage() {
    return ContactsStorageWeb();
  }

  @override
  FilesTransitManager createFilesTransitManager() {
    return FilesTransitManagerWeb();
  }

  @override
  FilesManager createFilesManager() {
    return FilesManagerWeb();
  }
}

PSHelper getInstanceImpl() => PSHelperWeb();
