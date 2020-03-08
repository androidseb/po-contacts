import 'package:po_contacts_flutter/controller/platform/mobile/basic_info_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/contacts_storage.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/files_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/files_transit_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class PSHelperMobile implements PSHelper {
  @override
  BasicInfoManager createBasicInfoManager() {
    return BasicInfoManagerMobile();
  }

  @override
  ContactsStorage createContactStorage() {
    return ContactsStorageMobile();
  }

  @override
  FilesTransitManager createFilesTransitManager() {
    return FilesTransitManagerMobile();
  }

  @override
  FilesManager createFilesManager() {
    return FilesManagerMobile();
  }
}

PSHelper getInstanceImpl() => PSHelperMobile();
