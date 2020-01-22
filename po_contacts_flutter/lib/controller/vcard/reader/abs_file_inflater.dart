abstract class FileEntry {
  Future<bool> writeBase64String(String base64String);
  String getAbsolutePath();
  Future<void> delete();
}

abstract class FileInflater<T extends FileEntry> {
  Future<T> createNewImageFile(String fileExtension);
}
