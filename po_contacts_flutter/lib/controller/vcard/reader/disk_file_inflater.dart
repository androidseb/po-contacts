import 'dart:io';

import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class DiskFileEntry extends FileEntry {
  final File file;
  DiskFileEntry(this.file);

  Future<bool> writeBase64String(String base64String) async {
    return await Utils.base64StringToFile(base64String, file);
  }

  String getAbsolutePath() {
    return file.absolute.path;
  }

  Future<void> delete() async {
    await file.delete();
  }
}

class DiskFileInflater extends FileInflater<DiskFileEntry> {
  @override
  Future<DiskFileEntry> createNewImageFile(String fileExtension) async {
    return DiskFileEntry(await MainController.get().createNewImageFile(fileExtension));
  }
}
