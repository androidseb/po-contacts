import 'dart:io';

import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_reader.dart';

class VCFFileReader extends VCFReader {
  final File _file;
  final Function(int progress) progressCallback;
  int _currentLine = 0;
  List<String> _lines;

  VCFFileReader(this._file, final FileInflater fileInflater, {this.progressCallback}) : super(fileInflater);

  @override
  Future<String> readLineImpl() async {
    if (_lines == null) {
      _lines = await _file.readAsLines();
    }
    if (_currentLine >= _lines.length) {
      return null;
    }
    String readLine;
    readLine = _lines[_currentLine];
    _currentLine++;
    await progressCallback((_currentLine * 100 / _lines.length).floor());
    return readLine;
  }
}
