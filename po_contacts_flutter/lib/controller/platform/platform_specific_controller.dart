import 'package:flutter/foundation.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.stub.dart'
    if (dart.library.io) 'package:po_contacts_flutter/controller/platform/mobile/platform_specific_controller.mobile.dart'
    if (dart.library.html) 'package:po_contacts_flutter/controller/platform/web/platform_specific_controller.web.dart';
import 'package:po_contacts_flutter/model/storage/contacts_storage_controller.dart';

enum PlatformType { ANDROID, IOS, WEB }

abstract class BasicInfoManager {
  PlatformType getPlatformType();

  bool _isWeb;
  bool _isAndroid;
  bool _isIOS;
  bool _isMobile;

  BasicInfoManager() {
    _isWeb = getPlatformType() == PlatformType.WEB;
    _isAndroid = getPlatformType() == PlatformType.ANDROID;
    _isIOS = getPlatformType() == PlatformType.IOS;
    _isMobile = _isAndroid || _isIOS;
  }

  bool get isWeb {
    return _isWeb;
  }

  bool get isAndroid {
    return _isAndroid;
  }

  bool get isIOS {
    return _isIOS;
  }

  bool get isMobile {
    return _isMobile;
  }
}

abstract class ContactsStorage {
  Future<List<ContactStorageEntryWithId>> readAllContacts();

  Future<ContactStorageEntryWithId> createContact(final ContactStorageEntry storageEntry);

  Future<ContactStorageEntryWithId> updateContact(final int contactId, final ContactStorageEntry storageEntry);

  Future<bool> deleteContact(final int contactId);
}

abstract class FilesTransitManager {
  Future<String> getInboxFileId();

  Future<void> discardInboxFileId(final String inboxFileId);

  Future<String> getCopiedInboxFilePath(final String inboxFileId);

  Future<String> getOutputFilesDirectoryPath();

  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath);
}

abstract class FilesManager {}

abstract class PSHelper {
  factory PSHelper() => getInstanceImpl();

  @protected
  BasicInfoManager createBasicInfoManager();

  @protected
  ContactsStorage createContactStorage();

  @protected
  FilesTransitManager createFilesTransitManager();

  @protected
  FilesManager createFilesManager();
}

class PlatformSpecificController {
  final PSHelper _psHelper = PSHelper();

  BasicInfoManager _basicInfoManager;
  ContactsStorage _contactsStorage;
  FilesTransitManager _filesTransitManager;
  FilesManager _filesManager;

  BasicInfoManager get basicInfoManager {
    if (_basicInfoManager == null) {
      _basicInfoManager = _psHelper.createBasicInfoManager();
    }
    return _basicInfoManager;
  }

  ContactsStorage get contactsStorage {
    if (_contactsStorage == null) {
      _contactsStorage = _psHelper.createContactStorage();
    }
    return _contactsStorage;
  }

  FilesTransitManager get fileTransitManager {
    if (_filesTransitManager == null) {
      _filesTransitManager = _psHelper.createFilesTransitManager();
    }
    return _filesTransitManager;
  }

  FilesManager get filesManager {
    if (_filesManager == null) {
      _filesManager = _psHelper.createFilesManager();
    }
    return _filesManager;
  }
}
