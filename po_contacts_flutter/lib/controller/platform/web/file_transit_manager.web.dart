import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'dart:async';

class FileTransitManagerWeb implements FilesTransitManager {
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
  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath) async {
    return;
  }
}