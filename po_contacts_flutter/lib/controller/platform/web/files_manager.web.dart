import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';

class FilesManagerWeb extends FilesManager {
  @override
  Future<FileEntity> createFileEntityAbsPath(String fileAbsPath) {
    //WebTodo
    return null;
  }

  @override
  Future<FileEntity> createFileEntityParentAndName(String parentFolderPath, String fileName) {
    //WebTodo
    return null;
  }

  @override
  Future<String> getApplicationDocumentsDirectoryPath() {
    //WebTodo
    return null;
  }

  @override
  Widget fileToImageWidget(FileEntity currentFile, {BoxFit fit, double imageWidth, double imageHeight}) {
    //WebTodo
    return null;
  }

  @override
  Future<FileEntity> pickImageFile(ImageFileSource imageFileSource) {
    //WebTodo
    return null;
  }
}
