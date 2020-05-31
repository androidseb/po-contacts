import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

class FileEntityMobile extends FileEntity {
  final File _file;

  FileEntityMobile(this._file);

  @override
  Future<FileEntity> create() async {
    if (!await _file.parent.exists()) {
      await _file.parent.create(recursive: true);
    }
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
  Future<bool> writeAsUint8List(final Uint8List outputData) {
    return FileEntityMobile.uint8ListToFile(outputData, _file);
  }

  static Future<bool> uint8ListToFile(final Uint8List outputData, final File destFile) async {
    try {
      await destFile.writeAsBytes(outputData);
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

  @override
  Future<void> flushOutputBuffer() async {
    //Not doing anything here. Any output written to this file are synchronous.
  }
}
