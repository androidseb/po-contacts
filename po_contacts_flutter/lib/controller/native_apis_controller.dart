import 'dart:async';

import 'package:flutter/services.dart';

class NativeApisController {
  static const platform = const MethodChannel('com.exlyo.pocontacts/files');

  Future<String> getInboxFileId() async {
    return await platform.invokeMethod('getInboxFileId');
  }

  Future<void> discardInboxFileId(final String inboxFileId) async {
    return await platform.invokeMethod('discardInboxFileId', {'inboxFileId': inboxFileId});
  }

  Future<String> getCopiedInboxFilePath(final String inboxFileId) async {
    return await platform.invokeMethod('getCopiedInboxFilePath', {'inboxFileId': inboxFileId});
  }

  Future<String> getOutputFilesDirectoryPath() async {
    return await platform.invokeMethod('getOutputFilesDirectoryPath');
  }

  Future<void> shareFileExternally(final String sharePromptTitle, final String filePath) async {
    await platform.invokeMethod('shareFileExternally', {'sharePromptTitle': sharePromptTitle, 'filePath': filePath});
  }
}
