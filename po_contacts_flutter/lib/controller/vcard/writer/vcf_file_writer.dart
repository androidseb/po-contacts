import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/common/files_manager.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';

class VCFFileWriter extends VCFWriter {
  final FileEntity _file;
  VCFFileWriter(final FilesManager filesManager, this._file) : super(FileReader(filesManager));

  @override
  void writeStringImpl(String line) {
    _file.writeAsStringAppendSync(line);
  }

  @override
  Future<void> flushOutputBuffer() {
    return _file.flushOutputBuffer();
  }
}
