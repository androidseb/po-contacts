import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';

class DiskFileInflater extends FileInflater<FileEntity?> {
  @override
  Future<FileEntity?> createNewImageFile(String fileExtension) async {
    return await MainController.get()!.createNewImageFile(fileExtension);
  }
}
