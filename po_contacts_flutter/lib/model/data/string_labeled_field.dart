import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class StringLabeledField extends LabeledField<String> {
  StringLabeledField(final LabeledFieldLabelType labelType, final String labelText, final String fieldValue)
      : super(labelType, labelText, fieldValue);

  @override
  dynamic fieldValueToJSONConvertable() {
    return fieldValue;
  }

  static LabeledField createFieldFunc(
    final LabeledFieldLabelType labelType,
    final String labelText,
    final dynamic fieldValue,
  ) {
    return StringLabeledField(labelType, labelText, fieldValue);
  }

  static bool areListsEqual(final List<StringLabeledField> list1, final List<StringLabeledField> list2) {
    if (list1 == list2) {
      return true;
    }
    if (list1 == null || list2 == null) {
      return false;
    }
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      final StringLabeledField item1 = list1[i];
      for (int j = 0; j < list2.length; j++) {
        final StringLabeledField item2 = list1[j];
        if (!StringLabeledField.areEqual(item1, item2)) {
          return false;
        }
      }
    }
    return true;
  }

  static bool areEqual(final StringLabeledField item1, final StringLabeledField item2) {
    if (item1 == item2) {
      return true;
    }
    if (item1 == null || item2 == null) {
      return false;
    }
    if (item1.labelType != item2.labelType) return false;
    if (item1.labelText != item2.labelText) return false;
    if (item1.fieldValue != item2.fieldValue) return false;
    return true;
  }
}
