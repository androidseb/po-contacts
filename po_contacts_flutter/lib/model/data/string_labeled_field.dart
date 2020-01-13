import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class StringLabeledField extends LabeledField<String> {
  StringLabeledField(final LabeledFieldLabelType labelType, final String labelValue, final String fieldValue)
      : super(labelType, labelValue, fieldValue);

  @override
  dynamic fieldValueToJSONConvertable() {
    return labelValue;
  }

  static LabeledField createFieldFunc(
    final LabeledFieldLabelType labelType,
    final String labelText,
    final dynamic fieldValue,
  ) {
    return StringLabeledField(labelType, labelText, fieldValue);
  }
}
