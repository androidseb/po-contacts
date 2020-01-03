enum LabeledFieldType {
  email,
  phone,
}

enum LabeledFieldLabelType {
  custom,
  work,
  home,
  cell,
}

class LabeledField {
  final LabeledFieldType fieldType;
  final String textValue;
  final LabeledFieldLabelType labelType;
  final String labelValue;

  LabeledField(
    this.fieldType,
    this.textValue,
    this.labelType,
    this.labelValue,
  );
}
