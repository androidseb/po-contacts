import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

abstract class FileInflater<T extends FileEntity?> {
  Future<T> createNewImageFile(String fileExtension);
}
