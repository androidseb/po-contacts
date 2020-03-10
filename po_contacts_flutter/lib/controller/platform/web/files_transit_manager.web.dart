//ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:convert';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_transit_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/file_entity.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/files_manager.web.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

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
    return WebAbstractFS.APPLICATION_DOCUMENTS_DIRECTORY_PATH;
  }

  @override
  Future<void> shareFileExternally(final String sharePromptTitle, final FileEntity file) async {
    if (file == null || !(file is FileEntityWeb)) {
      return;
    }
    final FileEntityWeb few = file;
    final String fileName = Utils.getFileName(few.getAbsolutePath());
    final String base64ContentString = base64Encode(few.binaryData);
    AnchorElement(href: 'data:application/octet-stream;charset=utf-8;base64,$base64ContentString')
      ..setAttribute('download', fileName)
      ..click();
  }
}
