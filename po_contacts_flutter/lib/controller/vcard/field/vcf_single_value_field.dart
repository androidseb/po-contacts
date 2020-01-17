import 'package:po_contacts_flutter/controller/vcard/field/vcf_field.dart';

class SingleValueField extends VCFField {
  final String fieldValue;
  SingleValueField(final Map<String, String> fieldParams, this.fieldValue) : super(fieldParams);

  static SingleValueField create(final String fieldName, final String fieldLine) {
    final Map<String, String> fieldParams = {};
    final int fieldValueStartIndex = VCFField.readFieldParamsFromLine(fieldName, fieldLine, fieldParams);
    final String fieldValueRawStr = fieldLine.substring(fieldValueStartIndex);
    final String fieldValueStr = VCFField.unEscapeVCFString(fieldValueRawStr, fieldParams: fieldParams);
    return SingleValueField(fieldParams, fieldValueStr);
  }
}
