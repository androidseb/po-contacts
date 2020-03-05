import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class FilesTransitManagerMobile implements FilesTransitManager {
  static const platform = const MethodChannel('com.exlyo.pocontacts/files');

  Future<String> _getInboxFileIdInDirForIOS(final Directory dir, final String inboxDirName) async {
    final List<FileSystemEntity> filesList = dir.listSync();
    FileSystemEntity foundInboxDir;
    for (final FileSystemEntity fse in filesList) {
      if (!fse.path.endsWith('/$inboxDirName')) {
        continue;
      }
      final fileStat = await fse.stat();
      if (fileStat.type != FileSystemEntityType.directory) {
        continue;
      }
      foundInboxDir = fse;
      break;
    }
    if (foundInboxDir == null) {
      return null;
    }
    final List<FileSystemEntity> inboxFilesList = Directory(foundInboxDir.path).listSync();
    for (final FileSystemEntity fse in inboxFilesList) {
      return fse.path;
    }
    return null;
  }

  Future<String> _getInboxFileIdForIOS() async {
    String foundInboxFileId;
    final Directory applicationDocumentsDir = await getApplicationDocumentsDirectory();
    foundInboxFileId = await _getInboxFileIdInDirForIOS(applicationDocumentsDir, 'Inbox');
    if (foundInboxFileId != null) {
      return foundInboxFileId;
    }
    final String tmpDirPath = applicationDocumentsDir.parent.path + '/tmp';
    foundInboxFileId = await _getInboxFileIdInDirForIOS(Directory(tmpDirPath), 'com.exlyo.pocontacts-Inbox');
    return foundInboxFileId;
  }

  @override
  Future<String> getInboxFileId() async {
    if (Platform.isIOS) {
      return _getInboxFileIdForIOS();
    }
    return await platform.invokeMethod('getInboxFileId');
  }

  @override
  Future<void> discardInboxFileId(final String inboxFileId) async {
    if (Platform.isIOS) {
      await File(inboxFileId).delete();
      return;
    }
    return await platform.invokeMethod('discardInboxFileId', {'inboxFileId': inboxFileId});
  }

  @override
  Future<String> getCopiedInboxFilePath(final String inboxFileId) async {
    if (Platform.isIOS) {
      return inboxFileId;
    }
    return await platform.invokeMethod('getCopiedInboxFilePath', {'inboxFileId': inboxFileId});
  }

  @override
  Future<String> getOutputFilesDirectoryPath() async {
    if (Platform.isIOS) {
      final Directory tempDir = await getTemporaryDirectory();
      return tempDir.path;
    }
    return await platform.invokeMethod('getOutputFilesDirectoryPath');
  }

  @override
  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath) async {
    await platform.invokeMethod('shareFileExternally', {'sharePromptTitle': sharePromptTitle, 'filePath': filePath});
  }
}
