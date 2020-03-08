import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/platform/web/basic_info_manager.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/contacts_storage_manager.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/files_manager.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/files_transit_manager.web.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_transit_manager.dart';

class PSHelperWeb implements PSHelper {
  @override
  BasicInfoManager createBasicInfoManager() {
    return BasicInfoManagerWeb();
  }

  @override
  ContactsStorageManager createContactStorageManager() {
    return ContactsStorageManagerWeb();
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
