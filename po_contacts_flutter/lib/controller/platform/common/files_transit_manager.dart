import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

abstract class FilesTransitManager {
  Future<String> getInboxFileId();

  Future<void> discardInboxFileId(final String inboxFileId);

  Future<String> getCopiedInboxFilePath(final String inboxFileId);

  Future<String> getOutputFilesDirectoryPath();

  Future<void> shareFileExternally(final String sharePromptTitle, final FileEntity file);
}
