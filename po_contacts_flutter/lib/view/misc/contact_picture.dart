import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';

class ContactPicture extends StatefulWidget {
  final FilesManager? filesManager = MainController.get()!.psController.filesManager;
  final String? imageFilePath;
  final double imageWidth;
  final double imageHeight;
  ContactPicture(this.imageFilePath, {this.imageWidth = 96, this.imageHeight = 96});

  _ContactPictureState createState() => _ContactPictureState();
}

class _ContactPictureState extends State<ContactPicture> {
  FileEntity? _currentFile;

  @override
  void initState() {
    _currentFile = null;
    loadImageFile();
    super.initState();
  }

  @override
  void didUpdateWidget(ContactPicture oldWidget) {
    _currentFile = null;
    loadImageFile();
    super.didUpdateWidget(oldWidget);
  }

  void loadImageFile() async {
    if (widget.filesManager == null || widget.imageFilePath == null) {
      return;
    }

    final FileEntity imageFile = await widget.filesManager!.createFileEntityAbsPath(widget.imageFilePath);
    final bool fileExists = await imageFile.exists();
    if (!fileExists) {
      return;
    }
    setState(() {
      _currentFile = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    if (_currentFile != null && widget.filesManager != null) {
      imageWidget = widget.filesManager!.fileToImageWidget(
        _currentFile,
        fit: BoxFit.cover,
        imageWidth: widget.imageWidth,
        imageHeight: widget.imageHeight,
      );
    }
    if (imageWidget == null) {
      imageWidget = Image.asset(
        'lib/assets/images/ic_profile.png',
        fit: BoxFit.cover,
        height: widget.imageWidth,
        width: widget.imageHeight,
      );
    }
    return ClipOval(
      clipBehavior: Clip.antiAlias,
      child: imageWidget,
    );
  }
}
