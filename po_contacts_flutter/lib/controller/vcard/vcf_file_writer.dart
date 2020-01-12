import 'dart:io';

import 'package:po_contacts_flutter/controller/vcard/vcf_writer.dart';

class VCFFileWriter extends VCFWriter {
  final File _file;
  VCFFileWriter(this._file);

  @override
  void writeStringImpl(String line) {
    _file.writeAsStringSync(line, mode: FileMode.append, flush: true);
  }
}
