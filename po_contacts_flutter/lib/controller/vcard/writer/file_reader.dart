import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class FileReader {
  final FilesManager _filesManager;

  FileReader(this._filesManager);

  Future<String> fileToBase64String(String filePath) async {
    final FileEntity fileEntity = await _filesManager.createFileEntityAbsPath(filePath);
    return fileEntity.readAsBase64String();
  }
}
