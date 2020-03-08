import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_transit_manager.dart';

class FilesTransitManagerWeb implements FilesTransitManager {
  @override
  Future<String> getInboxFileId() async {
    return null;
  }

  @override
  Future<void> discardInboxFileId(final String inboxFileId) async {}

  @override
  Future<String> getCopiedInboxFilePath(final String inboxFileId) async {
    return null;
  }

  @override
  Future<String> getOutputFilesDirectoryPath() async {
    return null;
  }

  @override
  Future<void> shareFileExternally(final String sharePromptTitle, final FileEntity file) async {
    return;
  }
}
