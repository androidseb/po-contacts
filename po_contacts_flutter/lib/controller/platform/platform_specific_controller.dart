import 'package:flutter/foundation.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/platform_specific_controller.mobile.dart'
    if (dart.library.io) 'package:po_contacts_flutter/controller/platform/web/platform_specific_controller.web.dart';

abstract class FilesTransitManager {
  Future<String> getInboxFileId();

  Future<void> discardInboxFileId(final String inboxFileId);

  Future<String> getCopiedInboxFilePath(final String inboxFileId);

  Future<String> getOutputFilesDirectoryPath();

  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath);
}

abstract class PSHelper {
  factory PSHelper() => getInstanceImpl();

  @protected
  FilesTransitManager createFilesTransitManager();
}

class PlatformSpecificController {
  final PSHelper _psHelper = PSHelper();

  FilesTransitManager _filesTransitManager;

  FilesTransitManager get fileTransitManager {
    if (_filesTransitManager == null) {
      _filesTransitManager = _psHelper.createFilesTransitManager();
    }
    return _filesTransitManager;
  }
}
