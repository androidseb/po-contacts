import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';

enum ImageFileSource { GALLERY, CAMERA, FILE_PICKER }

abstract class FilesManager {
  Future<FileEntity> createFileEntityParentAndName(final String parentFolderPath, final String fileName);

  Future<FileEntity> createFileEntityAbsPath(final String fileAbsPath);

  Future<String> getApplicationDocumentsDirectoryPath();

  Widget fileToImageWidget(final FileEntity currentFile,
      {final BoxFit fit, final double imageWidth, final double imageHeight});

  Future<FileEntity> pickImageFile(final ImageFileSource imageFileSource);
}
