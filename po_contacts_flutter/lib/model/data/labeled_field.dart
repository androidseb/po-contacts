import 'package:po_contacts_flutter/assets/i18n.dart';

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

  static String getTypeNameStringKey(final LabeledFieldLabelType labelType) {
    switch (labelType) {
      case LabeledFieldLabelType.work:
        return I18n.string.label_type_work;
      case LabeledFieldLabelType.home:
        return I18n.string.label_type_home;
      case LabeledFieldLabelType.cell:
        return I18n.string.label_type_cell;
      case LabeledFieldLabelType.custom:
        return I18n.string.label_type_custom;
    }
    return '???';
  }
}
