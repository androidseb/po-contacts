import 'dart:io';

import 'package:po_contacts_flutter/controller/vcard/writer/disk_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';

class VCFFileWriter extends VCFWriter {
  final File _file;
  VCFFileWriter(this._file) : super(DiskFileReader());

  @override
  void writeStringImpl(String line) {
    _file.writeAsStringSync(line, mode: FileMode.append, flush: true);
  }
}
