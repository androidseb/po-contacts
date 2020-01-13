import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class StringLabeledField extends LabeledField<String> {
  StringLabeledField(String fieldValue, LabeledFieldLabelType labelType, String labelValue)
      : super(fieldValue, labelType, labelValue);
}
