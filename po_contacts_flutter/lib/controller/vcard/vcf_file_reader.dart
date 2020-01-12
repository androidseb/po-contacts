import 'dart:io';

import 'package:po_contacts_flutter/controller/vcard/vcf_reader.dart';

class VCFFileReader extends VCFReader {
  final File _file;
  int _currentLine = 0;
  List<String> _lines;

  VCFFileReader(this._file);

  @override
  String readLineImpl() {
    if (_lines == null) {
      _lines = _file.readAsLinesSync();
    }
    if (_currentLine >= _lines.length) {
      return null;
    }
    final String readLine = _lines[_currentLine];
    _currentLine++;
    return readLine;
  }
}
