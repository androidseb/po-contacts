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
}
