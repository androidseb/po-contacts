import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/actions_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/basic_info_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/contacts_storage_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/files_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/files_transit_manager.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_transit_manager.dart';

class PSHelperMobile implements PSHelper {
  @override
  BasicInfoManager createBasicInfoManager() {
    return BasicInfoManagerMobile();
  }

  @override
  ContactsStorageManager createContactStorageManager() {
    return ContactsStorageManagerMobile();
  }

  @override
  FilesTransitManager createFilesTransitManager() {
    return FilesTransitManagerMobile();
  }

  @override
  FilesManager createFilesManager() {
    return FilesManagerMobile();
  }

  @override
  ActionsManager createActionsManager() {
    return ActionsManagerMobile();
  }
}

PSHelper getInstanceImpl() => PSHelperMobile();
