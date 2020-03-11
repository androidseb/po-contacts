import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/web/files_manager.web.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class FileEntityWeb extends FileEntity {
  WebAbstractFS _webFS;
  String _absolutePath;
  String _base64Content;
  Uint8List _binaryContent;

  FileEntityWeb(final WebAbstractFS webFS, final String absolutePath, final String base64Content) {
    _webFS = webFS;
    _absolutePath = absolutePath;
    _base64Content = base64Content;
  }

  String get base64Content {
    if (_base64Content == null) {
      _base64Content = _webFS.readFile(_absolutePath);
    }
    return _base64Content;
  }

  Uint8List get binaryData {
    if (_binaryContent == null) {
      final String latestBase64Content = base64Content;
      _binaryContent = latestBase64Content == null ? null : base64.decode(latestBase64Content);
    }
    return _binaryContent;
  }

  @override
  Future<FileEntity> create() async {
    _webFS.writeFile(_absolutePath, '');
    return this;
  }

  @override
  Future<bool> delete() async {
    _webFS.writeFile(_absolutePath, null);
    return true;
  }

  @override
  Future<bool> exists() async {
    return _webFS.readFile(_absolutePath) != null;
  }

  @override
  String getAbsolutePath() {
    return _absolutePath;
  }

  @override
  void writeAsStringAppendSync(String str) {
    final String latestBase64Content = base64Content;
    final String currentContentBase64 = latestBase64Content == null ? '' : latestBase64Content;
    final String currentContent = Utils.base64ToString(currentContentBase64);
    final String updatedContent = currentContent + str;
    writeAsBase64String(Utils.strToBase64(updatedContent));
  }

  @override
  Future<bool> writeAsBase64String(final String base64String) async {
    _base64Content = base64String;
    _binaryContent = null;
    _webFS.writeFile(_absolutePath, base64String);
    return true;
  }

  @override
  Future<List<String>> readAsLines() async {
    final Uint8List fileData = binaryData;
    if (fileData == null) {
      return List<String>();
    }
    final String fileContentAsString = utf8.decode(fileData);
    final List<String> intermediateResult = fileContentAsString.split('\n');
    final List<String> result = [];
    for (final String s in intermediateResult) {
      if (s.endsWith('\r')) {
        result.add(s.substring(0, s.length - 1));
      } else {
        result.add(s);
      }
    }
    return result;
  }

  @override
  Future<String> readAsBase64String() async {
    return base64Content;
  }

  @override
  Future<FileEntity> copy(final FileEntity targetFile) async {
    final String newFileAbsPath = targetFile.getAbsolutePath();
    _webFS.writeFile(newFileAbsPath, base64Content);
    return FileEntityWeb(_webFS, newFileAbsPath, base64Content);
  }
}
