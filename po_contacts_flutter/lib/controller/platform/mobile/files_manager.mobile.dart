import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/mobile/file_entity.mobile.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class FilesManagerMobile extends FilesManager {
  @override
  Future<FileEntity> createFileEntityParentAndName(final String parentFolderPath, final String fileName) async {
    return createFileEntityAbsPath('$parentFolderPath/$fileName');
  }

  @override
  Future<FileEntity> createFileEntityAbsPath(String fileAbsPath) async {
    return FileEntityMobile(File(fileAbsPath));
  }

  @override
  Future<String> getApplicationDocumentsDirectoryPath() async {
    final Directory internalAppDirectory = await getApplicationDocumentsDirectory();
    return internalAppDirectory.path;
  }

  @override
  Widget fileToImageWidget(
    final FileEntity currentFile, {
    final BoxFit fit,
    final double imageWidth,
    final double imageHeight,
  }) {
    return Image.file(
      File(currentFile.getAbsolutePath()),
      fit: BoxFit.cover,
      height: imageWidth,
      width: imageHeight,
    );
  }

  @override
  Future<FileEntity> pickImageFile(final ImageFileSource imageFileSource) async {
    ImageSource imgSource;
    switch (imageFileSource) {
      case ImageFileSource.CAMERA:
        imgSource = ImageSource.camera;
        break;
      case ImageFileSource.GALLERY:
        imgSource = ImageSource.gallery;
        break;
      case ImageFileSource.FILE_PICKER:
        imgSource = null;
        break;
    }
    if (imgSource == null) {
      return null;
    }
    final File selectedImageRawFile = await ImagePicker.pickImage(source: imgSource);
    final FileEntity selectedImageFile = FileEntityMobile(selectedImageRawFile);
    if (Platform.isAndroid) {
      final String fileExtension = Utils.getFileExtension(selectedImageFile.getAbsolutePath());
      //If the platform is Android, the file will not be in
      //the app's internal storage so we want to copy it there
      final FileEntity targetFile = await MainController.get().createNewImageFile(fileExtension);
      await selectedImageFile.copy(targetFile);

      //Also, if the file was created in the app's public folder
      //we want to delete it from there
      final Directory externalAppDirectory = await getExternalStorageDirectory();
      final String selectedImageParentPath = selectedImageRawFile.parent.absolute.path;
      final String externalAppDirectoryPath = externalAppDirectory.absolute.path;
      if (selectedImageParentPath.startsWith(externalAppDirectoryPath)) {
        selectedImageFile.delete();
      }

      return targetFile;
    }
    return selectedImageFile;
  }
}
