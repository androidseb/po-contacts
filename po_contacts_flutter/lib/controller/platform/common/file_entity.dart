import 'dart:convert';
import 'dart:typed_data';

abstract class FileEntity {
  static List<String> rawFileContentToLines(final String fileContentAsString) {
    final List<String> intermediateResult = fileContentAsString.split('\n');
    final List<String> result = [];
    for (final String s in intermediateResult) {
      if (s.endsWith('\r')) {
        result.add(s.substring(0, s.length - 1));
      } else {
        result.add(s);
      }
    }
    return result;
  }

  String getAbsolutePath();

  Future<bool> exists();

  Future<bool> delete();

  Future<FileEntity> create();

  Future<FileEntity> move(final FileEntity targetFile) async {
    await copy(targetFile);
    await delete();
    return targetFile;
  }

  Future<FileEntity> copy(final FileEntity targetFile);

  void writeAsStringAppendSync(String str);

  Future<List<String>> readAsLines();

  Future<bool> writeAsBase64String(final String base64String) {
    return writeAsUint8List(base64.decode(base64String));
  }

  Future<bool> writeAsUint8List(final Uint8List outputData);

  Future<String> readAsBase64String();

  Future<Uint8List> readAsBinaryData() async {
    return base64.decode(await readAsBase64String());
  }

  Future<void> flushOutputBuffer();
}
