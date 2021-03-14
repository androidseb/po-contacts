import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class StringLabeledField extends LabeledField<String?> {
  StringLabeledField(final LabeledFieldLabelType? labelType, final String? labelText, final String? fieldValue)
      : super(labelType, labelText, fieldValue);

  @override
  dynamic fieldValueToJSONConvertable() {
    return fieldValue;
  }

  static LabeledField createFieldFunc(
    final LabeledFieldLabelType? labelType,
    final String? labelText,
    final dynamic fieldValue,
  ) {
    return StringLabeledField(labelType, labelText, fieldValue);
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
