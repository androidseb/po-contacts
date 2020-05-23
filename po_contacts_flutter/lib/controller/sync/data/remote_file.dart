enum RemoteFileType {
  FOLDER,
  FILE,
}

class RemoteFile {
  final RemoteFileType fileType;
  final String fileId;
  final String fileName;

  RemoteFile(
    this.fileType,
    this.fileId,
    this.fileName,
  );
}
