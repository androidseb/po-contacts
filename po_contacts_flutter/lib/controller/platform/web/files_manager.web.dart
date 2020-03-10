//ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/platform/web/file_entity.web.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class WebAbstractFS {
  static const _FILE_KEY_PREFIX = 'abstractfs';

  final Window _htmlWindow = window;

  String readFile(final String fileAbsPath) {
    final String fileKey = '$_FILE_KEY_PREFIX://$fileAbsPath';
    return _htmlWindow.localStorage[fileKey];
  }

  void writeFile(final String fileAbsPath, final String base64ContentString) {
    final String fileKey = '$_FILE_KEY_PREFIX://$fileAbsPath';
    _htmlWindow.localStorage[fileKey] = base64ContentString;
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
    return createFileEntityAbsPath(parentFolderPath + '/' + fileName);
  }

  @override
  Future<String> getApplicationDocumentsDirectoryPath() async {
    return 'appDirectory';
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
    final Completer<String> fileNameCompleter = new Completer<String>();
    final Completer<String> fileContentCompleter = new Completer<String>();
    final InputElement input = document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';
    input.onChange.listen((e) async {
      final File file = input.files[0];
      final FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onError.listen((error) => fileContentCompleter.completeError(error));
      await reader.onLoad.first;
      fileNameCompleter.complete(file.name);
      final String dataUrl = reader.result as String;
      fileContentCompleter.complete(dataUrl);
    });
    input.click();
    final String selectedFileName = await fileNameCompleter.future;
    final String selectedFileBase64DataUrl = await fileContentCompleter.future;
    final String base64StringPrefix = 'base64,';
    int startIndex = 0;
    final int base64PrefixIndex = selectedFileBase64DataUrl.indexOf(base64StringPrefix);
    if (base64PrefixIndex > 0) {
      startIndex = base64PrefixIndex + base64StringPrefix.length;
    }
    final String selectedFileBase64String = selectedFileBase64DataUrl.substring(startIndex);
    final String fileExtension = Utils.getFileExtension(selectedFileName);
    final FileEntity targetFile = await MainController.get().createNewImageFile(fileExtension);
    if (targetFile == null) {
      return null;
    }
    _webFS.writeFile(targetFile.getAbsolutePath(), selectedFileBase64String);
    return FileEntityWeb(_webFS, targetFile.getAbsolutePath(), selectedFileBase64String);
  }
}
