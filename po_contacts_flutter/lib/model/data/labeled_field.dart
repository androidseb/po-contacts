import 'package:po_contacts_flutter/assets/i18n.dart';

enum LabeledFieldLabelType {
  custom,
  work,
  home,
  cell,
}

const String LABEL_FIELD_TYPE_CUSTOM = 'custom';
const String LABEL_FIELD_TYPE_WORK = 'work';
const String LABEL_FIELD_TYPE_HOME = 'home';
const String LABEL_FIELD_TYPE_CELL = 'cell';

const Map<String, LabeledFieldLabelType> _stringToLfLabelType = {
  LABEL_FIELD_TYPE_CUSTOM: LabeledFieldLabelType.custom,
  LABEL_FIELD_TYPE_WORK: LabeledFieldLabelType.work,
  LABEL_FIELD_TYPE_HOME: LabeledFieldLabelType.home,
  LABEL_FIELD_TYPE_CELL: LabeledFieldLabelType.cell,
};

const Map<LabeledFieldLabelType, String> _lfLabelTypeToString = {
  LabeledFieldLabelType.custom: LABEL_FIELD_TYPE_CUSTOM,
  LabeledFieldLabelType.work: LABEL_FIELD_TYPE_WORK,
  LabeledFieldLabelType.home: LABEL_FIELD_TYPE_HOME,
  LabeledFieldLabelType.cell: LABEL_FIELD_TYPE_CELL,
};

LabeledFieldLabelType _stringToLabeledFieldLabelType(final String _string) {
  final LabeledFieldLabelType lfLabelType = _stringToLfLabelType[_string];
  if (lfLabelType == null) {
    return LabeledFieldLabelType.work;
  } else {
    return lfLabelType;
  }
}

String _labeledFieldLabelTypeToString(final LabeledFieldLabelType _lfLabelType) {
  final String lfLabelTypeString = _lfLabelTypeToString[_lfLabelType];
  if (lfLabelTypeString == null) {
    return LABEL_FIELD_TYPE_WORK;
  } else {
    return lfLabelTypeString;
  }
}

class LabeledField {
  static const String FIELD_TEXT_VALUE = 'text_value';
  static const String FIELD_LABEL_TYPE = 'label_type';
  static const String FIELD_LABEL_VALUE = 'label_value';

  static List<Map<String, dynamic>> fieldsToMapList(final List<LabeledField> labeledFields) {
    final List<Map<String, dynamic>> res = [];
    if (labeledFields == null) {
      return res;
    }
    for (final LabeledField lf in labeledFields) {
      res.add(_fieldToMap(lf));
    }
    return res;
  }

  static Map<String, dynamic> _fieldToMap(final LabeledField labeledField) {
    return {
      FIELD_TEXT_VALUE: labeledField.textValue,
      FIELD_LABEL_TYPE: _labeledFieldLabelTypeToString(labeledField.labelType),
      FIELD_LABEL_VALUE: labeledField.labelValue,
    };
  }

  static List<LabeledField> fromMapList(final List<dynamic> mapList) {
    final List<LabeledField> res = [];
    if (mapList == null) {
      return res;
    }
    for (final dynamic map in mapList) {
      if (map is Map<String, dynamic>) {
        res.add(_fromMap(map));
      }
    }
    return res;
  }

  static LabeledField _fromMap(final Map<String, dynamic> _map) {
    final String textValue = _map[FIELD_TEXT_VALUE];
    final LabeledFieldLabelType labelType = _stringToLabeledFieldLabelType(_map[FIELD_LABEL_TYPE]);
    final String labelValue = _map[FIELD_LABEL_VALUE];
    return LabeledField(
      textValue,
      labelType,
      labelValue,
    );
  }

  final String textValue;
  final LabeledFieldLabelType labelType;
  final String labelValue;

  LabeledField(
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
