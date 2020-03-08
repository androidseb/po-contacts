import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/platform/platform_specific_controller.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';

class VCFFileWriter extends VCFWriter {
  final FileEntity _file;
  VCFFileWriter(final FilesManager filesManager, this._file) : super(FileReader(filesManager));

  @override
  void writeStringImpl(String line) {
    _file.writeAsStringAppendSync(line);
  }
}
