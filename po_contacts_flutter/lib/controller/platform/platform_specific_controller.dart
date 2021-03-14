import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/platform/common/actions_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.stub.dart'
    if (dart.library.io) 'package:po_contacts_flutter/controller/platform/mobile/platform_specific_controller.mobile.dart'
    if (dart.library.html) 'package:po_contacts_flutter/controller/platform/web/platform_specific_controller.web.dart';
import 'package:po_contacts_flutter/controller/platform/common/basic_info_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/contacts_storage_manager.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_transit_manager.dart';

abstract class PSHelper {
  factory PSHelper() => getInstanceImpl();

  @protected
  BasicInfoManager createBasicInfoManager();

  @protected
  ContactsStorageManager createContactStorageManager();

  @protected
  FilesTransitManager createFilesTransitManager();

  @protected
  FilesManager createFilesManager();

  @protected
  ActionsManager createActionsManager();
}

class PlatformSpecificController {
  final PSHelper _psHelper = PSHelper();

  BasicInfoManager? _basicInfoManager;
  ContactsStorageManager? _contactsStorage;
  FilesTransitManager? _filesTransitManager;
  FilesManager? _filesManager;
  ActionsManager? _actionsManager;

  BasicInfoManager? get basicInfoManager {
    if (_basicInfoManager == null) {
      _basicInfoManager = _psHelper.createBasicInfoManager();
    }
    return _basicInfoManager;
  }

  ContactsStorageManager? get contactsStorage {
    if (_contactsStorage == null) {
      _contactsStorage = _psHelper.createContactStorageManager();
    }
    return _contactsStorage;
  }

  FilesTransitManager? get fileTransitManager {
    if (_filesTransitManager == null) {
      _filesTransitManager = _psHelper.createFilesTransitManager();
    }
    return _filesTransitManager;
  }

  FilesManager? get filesManager {
    if (_filesManager == null) {
      _filesManager = _psHelper.createFilesManager();
    }
    return _filesManager;
  }

  ActionsManager? get actionsManager {
    if (_actionsManager == null) {
      _actionsManager = _psHelper.createActionsManager();
    }
    return _actionsManager;
  }
}
