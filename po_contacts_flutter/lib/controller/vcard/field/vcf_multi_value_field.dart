import 'package:po_contacts_flutter/controller/vcard/field/vcf_field.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';

class MultiValueField extends VCFField {
  final List<String> fieldValues;
  MultiValueField(final Map<String, String> fieldParams, this.fieldValues) : super(fieldParams);

  static List<String> _readFieldValues(final String fieldValuesStr) {
    final List<String> res = [];

    int currentIndex = 0;
    int fieldValueEndIndex = VCFField.getNextSeparatorIndex(
      fieldValuesStr,
      currentIndex,
      [VCFConstants.VCF_SEPARATOR_SEMICOLON],
    );
    while (fieldValueEndIndex != -1) {
      if (fieldValueEndIndex > currentIndex) {
        final String fieldValueRawStr = fieldValuesStr.substring(currentIndex, fieldValueEndIndex);
        final String fieldValueStr = VCFField.unEscapeVCFString(fieldValueRawStr);
        res.add(fieldValueStr);
      }
      currentIndex = fieldValueEndIndex;
      fieldValueEndIndex = VCFField.getNextSeparatorIndex(
        fieldValuesStr,
        currentIndex,
        [VCFConstants.VCF_SEPARATOR_SEMICOLON],
      );
    }

    return res;
  }

  static MultiValueField create(final String fieldName, final String fieldLine) {
    final Map<String, String> fieldParams = {};
    final int fieldValueStartIndex = VCFField.readFieldParamsFromLine(fieldName, fieldLine, fieldParams);
    final String fieldValuesStr = fieldLine.substring(fieldValueStartIndex);
    final List<String> fieldValues = _readFieldValues(fieldValuesStr);
    return MultiValueField(fieldParams, fieldValues);
  }
}
