import 'package:po_contacts_flutter/controller/platform/mobile/platform_specific_controller.mobile.dart'
    if (dart.library.io) 'package:po_contacts_flutter/controller/platform/web/platform_specific_controller.web.dart';

abstract class PlatformSpecificController {
  factory PlatformSpecificController() => getInstanceImpl();

  Future<String> getInboxFileId();

  Future<void> discardInboxFileId(final String inboxFileId);

  Future<String> getCopiedInboxFilePath(final String inboxFileId);

  Future<String> getOutputFilesDirectoryPath();

  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath);
}
