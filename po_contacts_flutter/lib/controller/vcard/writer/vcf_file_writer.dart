import 'dart:convert';
import 'dart:typed_data';

import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/utils/encryption_utils.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class VCFFileWriter extends VCFWriter {
  final FileEntity _file;
  final String _encryptionKey;
  final List<String> _outputBuffer = [];
  VCFFileWriter(final FilesManager filesManager, this._file, this._encryptionKey) : super(FileReader(filesManager));

  @override
  void writeStringImpl(String line) {
    _outputBuffer.add(line);
  }

  @override
  Future<void> flushOutputBuffer() {
    final String outputPlainText = _outputBuffer.join();
    final Uint8List outputPlainBytes = utf8.encode(outputPlainText);
    Uint8List outputFinalBytes;
    if (_encryptionKey == null || _encryptionKey.isEmpty) {
      outputFinalBytes = outputPlainBytes;
    } else {
      final Uint8List fileHeaderContent = utf8.encode(VCFSerializer.ENCRYPTED_FILE_PREFIX);
      final Uint8List outputEncryptedBytes = EncryptionUtils.encryptData(outputPlainBytes, _encryptionKey);
      outputFinalBytes = Utils.combineUint8Lists(fileHeaderContent, outputEncryptedBytes);
    }
    final String outputBase64String = base64.encode(outputFinalBytes);
    _file.writeAsBase64String(outputBase64String);
    return _file.flushOutputBuffer();
  }
}
