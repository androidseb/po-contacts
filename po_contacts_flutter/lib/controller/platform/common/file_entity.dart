abstract class FileEntity {
  String getAbsolutePath();

  Future<bool> exists();

  Future<bool> delete();

  Future<FileEntity> create();

  Future<FileEntity> copy(final FileEntity targetFile);

  void writeAsStringAppendSync(String str);

  Future<List<String>> readAsLines();

  Future<bool> writeAsBase64String(String base64String);

  Future<String> readAsBase64String();

  Future<void> flushOutputBuffer();
}
