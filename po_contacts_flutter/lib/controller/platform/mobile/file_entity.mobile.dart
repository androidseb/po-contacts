import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

class FileEntityMobile extends FileEntity {
  final File _file;

  FileEntityMobile(this._file);

  @override
  Future<FileEntity> create() async {
    final File createdFile = await _file.create();
    return FileEntityMobile(createdFile);
  }

  @override
  Future<bool> delete() async {
    try {
      await _file.delete();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> exists() {
    return _file.exists();
  }

  @override
  String getAbsolutePath() {
    return _file.path;
  }

  @override
  void writeAsStringAppendSync(String str) {
    _file.writeAsStringSync(str, mode: FileMode.append, flush: true);
  }

  @override
  Future<bool> writeAsBase64String(String base64String) async {
    return await FileEntityMobile.base64StringToFile(base64String, _file);
  }

  static Future<bool> base64StringToFile(final String base64String, final File destFile) async {
    try {
      final Uint8List bytes = base64.decode(base64String);
      await destFile.writeAsBytes(bytes);
    } catch (e) {
      return false;
    }
    return true;
  }

  @override
  Future<List<String>> readAsLines() {
    return _file.readAsLines();
  }

  @override
  Future<String> readAsBase64String() {
    return fileContentToBase64String(_file);
  }

  static Future<String> fileContentToBase64String(final File file) async {
    try {
      if (!await file.exists()) {
        return null;
      }
      final Uint8List fileBytes = await file.readAsBytes();
      return base64.encode(fileBytes);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<FileEntity> copy(FileEntity targetFile) async {
    return FileEntityMobile(await _file.copy(targetFile.getAbsolutePath()));
  }
}
