import 'package:po_contacts_flutter/controller/vcard/field/vcf_single_value_field.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

abstract class VCFReader {
  String readLineImpl();

  String _pendingReadLine;

  String _readFieldLine() {
    String readLine;
    if (_pendingReadLine == null) {
      readLine = readLineImpl();
    } else {
      readLine = _pendingReadLine;
      _pendingReadLine = null;
    }
    if (readLine == null) {
      return null;
    }
    final StringBuffer res = new StringBuffer();
    while (true) {
      if (readLine != null) {
        res.write(readLine);
        readLine = readLineImpl();
      }
      if (readLine == null) {
        break;
      } else if (!readLine.startsWith(' ')) {
        _pendingReadLine = readLine;
        break;
      }
    }
    return res.toString();
  }

  List<String> _readContactFieldLines() {
    final List<String> res = [];
    String fieldLine;

    //Process all field lines until we find the BEGIN:VCARD field
    fieldLine = _readFieldLine();
    while (fieldLine != null && !fieldLine.startsWith(VCFConstants.FIELD_BEGIN_VCARD)) {
      fieldLine = _readFieldLine();
    }

    //If we couldn't get to the BEGIN:VCARD field, we stop here
    if (fieldLine == null) {
      return res;
    }

    //We add all lines we find until we hit reach a END:VCARD field or the end of the file
    fieldLine = _readFieldLine();
    while (fieldLine != null && !fieldLine.startsWith(VCFConstants.FIELD_END_VCARD)) {
      res.add(fieldLine);
      fieldLine = _readFieldLine();
    }

    return res;
  }

  void processContactFieldLine(final ContactBuilder contactBuilder, final String fieldLine) {
    if (fieldLine == null) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_FULL_NAME))) {
      final SingleValueField fnField = SingleValueField.create(VCFConstants.FIELD_FULL_NAME, fieldLine);
      if (fnField != null) {
        contactBuilder.setFullName(fnField.fieldValue);
      }
      return;
    }

    //TODO read other fields too
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_NAME))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_NICKNAME))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_ADRESS))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_PHONE))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_EMAIL))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_TITLE))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_ROLE))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_ORG))) {
      return;
    }
    if (fieldLine.startsWith(RegExp.escape(VCFConstants.FIELD_NOTE))) {
      return;
    }

    //If none of the above were recognized as a field, we save this as an unknown field line
    //This will ensure no imported contact fields are lost when we export
    contactBuilder.addUnknownVCFFieldLine(fieldLine);
  }

  ContactBuilder readContact() {
    final ContactBuilder res = new ContactBuilder();
    final List<String> contactFieldLines = _readContactFieldLines();
    if (contactFieldLines.isEmpty) {
      return null;
    }
    for (final String fieldLine in contactFieldLines) {
      processContactFieldLine(res, fieldLine);
    }
    return res;
  }
}
