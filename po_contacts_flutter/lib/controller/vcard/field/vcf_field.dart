import 'dart:math';

import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class VCFFieldLabelParamValue {
  final LabeledFieldLabelType labelType;
  final String labelText;

  VCFFieldLabelParamValue(
    this.labelType,
    this.labelText,
  );
}

abstract class VCFField {
  final Map<String, String> fieldParams;
  VCFField(this.fieldParams);

  static String unEscapeVCFString(final String str) {
    return str.replaceAll('\\', '');
  }

  //Retrieve the index of the next character in the string that is a non-escaped separator
  static int getNextSeparatorIndex(
    final String str,
    final int startIndex,
    final List<String> separatorChars,
  ) {
    if (startIndex >= str.length) {
      return -1;
    }
    String lastChar;
    for (int i = startIndex; i < str.length; i++) {
      final String currentChar = str[i];
      //If the current character is a separator character
      if (separatorChars.contains(currentChar)) {
        //If that separator character is not preceeded by a backslash
        if (lastChar == null || lastChar != '\\') {
          return i;
        }
      }
      lastChar = currentChar;
    }
    return -1;
  }

  static void _readFieldParamFromString(
    final String fieldParamString,
    final Map<String, String> fieldParams,
  ) {
    if (fieldParamString.isEmpty) {
      return;
    }
    int equalSeparatorIndex = getNextSeparatorIndex(
      fieldParamString,
      0,
      [VCFConstants.VCF_SEPARATOR_EQUAL],
    );
    if (equalSeparatorIndex == -1) {
      equalSeparatorIndex = fieldParamString.length;
    }
    final String fieldName = fieldParamString.substring(0, equalSeparatorIndex);
    final String fieldRawValue = fieldParamString.substring(min(fieldParamString.length, equalSeparatorIndex + 1));
    final String fieldValue = unEscapeVCFString(fieldRawValue);
    fieldParams[fieldName] = fieldValue;
  }

  static void _readFieldParamsFromString(
    final String fieldParamsString,
    final Map<String, String> fieldParams,
  ) {
    int currentIndex = 0;
    int fieldParamEndIndex = getNextSeparatorIndex(
      fieldParamsString,
      currentIndex,
      [VCFConstants.VCF_SEPARATOR_SEMICOLON],
    );
    while (true) {
      String fieldParamRawString;
      if (fieldParamEndIndex == -1) {
        fieldParamRawString = fieldParamsString.substring(currentIndex);
      } else {
        fieldParamRawString = fieldParamsString.substring(currentIndex, fieldParamEndIndex);
      }
      if (currentIndex == fieldParamEndIndex) {
        fieldParamEndIndex++;
        if (fieldParamEndIndex >= fieldParamsString.length) {
          break;
        }
      } else {
        _readFieldParamFromString(
          fieldParamRawString,
          fieldParams,
        );
      }
      if (fieldParamEndIndex == -1) {
        break;
      }
      currentIndex = fieldParamEndIndex;
      fieldParamEndIndex = getNextSeparatorIndex(
        fieldParamsString,
        currentIndex,
        [VCFConstants.VCF_SEPARATOR_SEMICOLON],
      );
    }
  }

  static int readFieldParamsFromLine(
    final String fieldName,
    final String fieldLine,
    final Map<String, String> fieldParams,
  ) {
    final int afterFieldNameIndex = fieldName.length + 1;
    final int fieldValueStartIndex = getNextSeparatorIndex(
      fieldLine,
      afterFieldNameIndex,
      [VCFConstants.VCF_SEPARATOR_COLON],
    );
    if (fieldValueStartIndex == -1) {
      return afterFieldNameIndex;
    }
    _readFieldParamsFromString(
      fieldLine.substring(afterFieldNameIndex, fieldValueStartIndex),
      fieldParams,
    );
    return fieldValueStartIndex + 1;
  }
}
