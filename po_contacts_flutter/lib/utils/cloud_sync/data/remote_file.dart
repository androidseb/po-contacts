enum RemoteFileType {
  FOLDER,
  FILE,
}

class RemoteFile {
  final RemoteFileType fileType;
  final String fileId;
  final String fileName;
  final String fileETag;

  RemoteFile(
    this.fileType,
    this.fileId,
    this.fileName,
    this.fileETag,
  );
}
