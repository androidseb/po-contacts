import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

abstract class VCFWriter {
  void writeStringImpl(final String line);

  void writeLine(final String line) {
    //We choose to not respect the "Line Delimiting and Folding" strictly:
    //https://tools.ietf.org/html/rfc6350#section-3.2
    //It seems the rationale behind having adding this complication is "older software support".
    //If the need arises, this can easily be updated and users can re-exported later after app update,
    //since the read functionality handles any line sizes.
    writeStringImpl(line + VCFConstants.VCF_LINE_RETURN_FIELD_SEPARATION);
  }

  String _escapeStringToVCF(final String str) {
    String res = str;
    VCFConstants.VCF_ESCAPED_CHARS_MAP.forEach((key, value) {
      res = res.replaceAll(key, value);
    });
    return res;
  }

  void _writeVCFStringFieldValue(final String fieldName, final String fieldValue) {
    writeLine(fieldName + ':' + _escapeStringToVCF(fieldValue));
  }

  void writeContactFields(final Contact contact) {
    _writeVCFStringFieldValue(VCFConstants.FIELD_FULL_NAME, contact.fullName);
    //TODO write the other fields too
  }

  void writeContact(final Contact contact) {
    if (contact == null) {
      return;
    }

    writeLine(VCFConstants.FIELD_BEGIN_VCARD);
    writeLine(VCFConstants.FIELD_VERSION);
    writeContactFields(contact);
    writeLine(VCFConstants.FIELD_END_VCARD);
    writeLine('');
  }
}
