//ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html';

import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/file_entity.web.dart';
import 'package:po_contacts_flutter/controller/platform/web/utils.web.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class WebAbstractFS {
  static const APPLICATION_DOCUMENTS_DIRECTORY_PATH = 'appDirectory';
  static const _FILE_KEY_PREFIX = 'abstractfs';

  final Window _htmlWindow = window;

  String readFile(final String fileAbsPath) {
    final String fileKey = '$_FILE_KEY_PREFIX://$fileAbsPath';
    return _htmlWindow.localStorage[fileKey];
  }

  void writeFile(final String fileAbsPath, final String base64ContentString) {
    final String fileKey = '$_FILE_KEY_PREFIX://$fileAbsPath';
    if (base64ContentString == null) {
      _htmlWindow.localStorage.remove(fileKey);
    } else {
      _htmlWindow.localStorage[fileKey] = base64ContentString;
    }
  }
}

class FilesManagerWeb extends FilesManager {
  final WebAbstractFS _webFS = WebAbstractFS();

  @override
  Future<FileEntity> createFileEntityAbsPath(final String fileAbsPath) async {
    return FileEntityWeb(_webFS, fileAbsPath, null);
  }

  @override
  Future<FileEntity> createFileEntityParentAndName(final String parentFolderPath, final String fileName) {
    return createFileEntityAbsPath('$parentFolderPath/$fileName');
  }

  @override
  Future<String> getApplicationDocumentsDirectoryPath() async {
    return WebAbstractFS.APPLICATION_DOCUMENTS_DIRECTORY_PATH;
  }

  @override
  Widget fileToImageWidget(
    final FileEntity currentFile, {
    final BoxFit fit,
    final double imageWidth,
    final double imageHeight,
  }) {
    if (currentFile is FileEntityWeb) {
      final FileEntityWeb few = currentFile;
      return Image.memory(
        few.binaryData,
        fit: BoxFit.cover,
        height: imageWidth,
        width: imageHeight,
      );
    } else {
      return null;
    }
  }

  @override
  Future<FileEntity> pickImageFile(final ImageFileSource imageFileSource) async {
    if (imageFileSource != ImageFileSource.FILE_PICKER) {
      return null;
    }
    final SelectedFileWeb selectedFile = await UtilsWeb.selectFile('image/*');
    if (selectedFile == null) {
      return null;
    }
    final String fileExtension = Utils.getFileExtension(selectedFile.fileName);
    final FileEntity targetFile = await MainController.get().createNewImageFile(fileExtension);
    if (targetFile == null) {
      return null;
    }
    _webFS.writeFile(targetFile.getAbsolutePath(), selectedFile.fileBase64ContentString);
    return FileEntityWeb(_webFS, targetFile.getAbsolutePath(), selectedFile.fileBase64ContentString);
  }
}
