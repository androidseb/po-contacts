import 'package:po_contacts_flutter/controller/platform/mobile/contacts_storage.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/file_transit_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class PSHelperMobile implements PSHelper {
  @override
  ContactsStorage createContactStorage() {
    return ContactsStorageMobile();
  }

  @override
  FilesTransitManager createFilesTransitManager() {
    return FileTransitManagerMobile();
  }
}

PSHelper getInstanceImpl() => PSHelperMobile();
