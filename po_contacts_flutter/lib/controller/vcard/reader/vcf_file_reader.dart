import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/utils/encryption_utils.dart';
import 'package:po_contacts_flutter/utils/main_queue_yielder.dart';
import 'package:po_contacts_flutter/utils/tasks_set_progress_callback.dart';

class VCFFileReader extends VCFReader {
  final FileEntity _file;
  final String? _encryptionKey;
  final TaskSetProgressCallback? progressCallback;
  int _currentLine = 0;
  List<String>? _lines;

  VCFFileReader(this._file, this._encryptionKey, final FileInflater fileInflater, {this.progressCallback})
      : super(fileInflater);

  Future<List<String>> _readLines() async {
    if (_encryptionKey == null) {
      return _file.readAsLines();
    }
    final String base64RawContent = await (_file.readAsBase64String() as Future<String>);
    final Uint8List rawContentBytes = base64.decode(base64RawContent);
    final Uint8List headerLessContentBytes = rawContentBytes.sublist(VCFSerializer.ENCRYPTED_FILE_PREFIX.length);
    final Uint8List decryptedContentBytes = await EncryptionUtils.decryptData(
      headerLessContentBytes,
      _encryptionKey,
      progressCallback: progressCallback,
    );
    final String decryptedContent = utf8.decode(decryptedContentBytes);
    final List<String> res = FileEntity.rawFileContentToLines(decryptedContent);
    await progressCallback?.reportOneTaskCompleted();
    await MainQueueYielder.check();
    return res;
  }

  @override
  Future<String?> readLineImpl() async {
    if (_lines == null) {
      _lines = await _readLines();
    }
    if (_currentLine >= _lines!.length) {
      return null;
    }
    String readLine;
    readLine = _lines![_currentLine];
    _currentLine++;
    await progressCallback?.broadcastProgress(_currentLine / _lines!.length);
    await MainQueueYielder.check();
    return readLine;
  }
}
