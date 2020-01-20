import 'dart:io';

import 'package:flutter/widgets.dart';

class ContactPicture extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final String imageFilePath;
  ContactPicture(this.imageFilePath, {this.imageWidth = 96, this.imageHeight = 96});

  _ContactPictureState createState() => _ContactPictureState();
}

class _ContactPictureState extends State<ContactPicture> {
  File _currentFile;

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
    if (widget.imageFilePath == null) {
      return;
    }
    final File imageFile = File(widget.imageFilePath);
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
    Widget imageWidget;
    if (_currentFile == null) {
      imageWidget = Image.asset(
        'lib/assets/images/ic_profile.png',
        fit: BoxFit.cover,
        height: widget.imageWidth,
        width: widget.imageHeight,
      );
    } else {
      imageWidget = Image.file(
        _currentFile,
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
