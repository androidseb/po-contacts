import 'package:po_contacts_flutter/assets/i18n.dart';

//TODO add some unit tests to lock down the indexes
enum LabeledFieldLabelType {
  custom,
  work,
  home,
  cell,
  fax,
  pager,
}

const String LABEL_FIELD_TYPE_CUSTOM = 'custom';
const String LABEL_FIELD_TYPE_WORK = 'work';
const String LABEL_FIELD_TYPE_HOME = 'home';
const String LABEL_FIELD_TYPE_CELL = 'cell';
const String LABEL_FIELD_TYPE_FAX = 'fax';
const String LABEL_FIELD_TYPE_PAGER = 'pager';

const Map<String, LabeledFieldLabelType> _stringToLfLabelType = {
  LABEL_FIELD_TYPE_CUSTOM: LabeledFieldLabelType.custom,
  LABEL_FIELD_TYPE_WORK: LabeledFieldLabelType.work,
  LABEL_FIELD_TYPE_HOME: LabeledFieldLabelType.home,
  LABEL_FIELD_TYPE_CELL: LabeledFieldLabelType.cell,
  LABEL_FIELD_TYPE_FAX: LabeledFieldLabelType.fax,
  LABEL_FIELD_TYPE_PAGER: LabeledFieldLabelType.pager,
};

const Map<LabeledFieldLabelType, String> _lfLabelTypeToString = {
  LabeledFieldLabelType.custom: LABEL_FIELD_TYPE_CUSTOM,
  LabeledFieldLabelType.work: LABEL_FIELD_TYPE_WORK,
  LabeledFieldLabelType.home: LABEL_FIELD_TYPE_HOME,
  LabeledFieldLabelType.cell: LABEL_FIELD_TYPE_CELL,
  LabeledFieldLabelType.fax: LABEL_FIELD_TYPE_FAX,
  LabeledFieldLabelType.pager: LABEL_FIELD_TYPE_PAGER,
};

abstract class LabeledField<T> {
  static const String FIELD_LABEL_TYPE = 'label_type';
  static const String FIELD_LABEL_VALUE = 'label_value';
  static const String FIELD_TEXT_VALUE = 'text_value';

  static LabeledFieldLabelType stringToLabeledFieldLabelType(
      final String str, final LabeledFieldLabelType defaultValue) {
    final LabeledFieldLabelType lfLabelType = _stringToLfLabelType[str.toLowerCase()];
    if (lfLabelType == null) {
      return defaultValue;
    } else {
      return lfLabelType;
    }
  }

  static String getTypeNameStringKey(final LabeledFieldLabelType labelType) {
    switch (labelType) {
      case LabeledFieldLabelType.work:
        return I18n.string.label_type_work;
      case LabeledFieldLabelType.home:
        return I18n.string.label_type_home;
      case LabeledFieldLabelType.cell:
        return I18n.string.label_type_cell;
      case LabeledFieldLabelType.fax:
        return I18n.string.label_type_fax;
      case LabeledFieldLabelType.pager:
        return I18n.string.label_type_pager;
      case LabeledFieldLabelType.custom:
        return I18n.string.label_type_custom;
    }
    return '???';
  }

  static String getLabelTypeDisplayText(final LabeledField entry) {
    if (entry.labelType == LabeledFieldLabelType.custom) {
      return entry.labelText;
    } else {
      return I18n.getString(LabeledField.getTypeNameStringKey(entry.labelType));
    }
  }

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

  static String labeledFieldLabelTypeToString(final LabeledFieldLabelType _lfLabelType) {
    final String lfLabelTypeString = _lfLabelTypeToString[_lfLabelType];
    if (lfLabelTypeString == null) {
      return LABEL_FIELD_TYPE_WORK;
    } else {
      return lfLabelTypeString;
    }
  }

  static Map<String, dynamic> _fieldToMap(final LabeledField labeledField) {
    return {
      FIELD_LABEL_TYPE: labeledFieldLabelTypeToString(labeledField.labelType),
      FIELD_LABEL_VALUE: labeledField.labelText,
      FIELD_TEXT_VALUE: labeledField.fieldValueToJSONConvertable(),
    };
  }

  static List<LabeledField> fromMapList(
    final List<dynamic> destList,
    final List<dynamic> mapList,
    final LabeledField Function(
      LabeledFieldLabelType labelType,
      String labelText,
      dynamic fieldValue,
    )
        createFieldFunc,
  ) {
    if (mapList == null) {
      return destList;
    }
    for (final dynamic map in mapList) {
      if (map is Map<String, dynamic>) {
        destList.add(_fromMap(map, createFieldFunc));
      }
    }
    return destList;
  }

  static LabeledField _fromMap(
    final Map<String, dynamic> _map,
    final LabeledField Function(
      LabeledFieldLabelType labelType,
      String labelText,
      dynamic fieldValue,
    )
        createFieldFunc,
  ) {
    final LabeledFieldLabelType labelType = LabeledField.stringToLabeledFieldLabelType(
      _map[FIELD_LABEL_TYPE],
      LabeledFieldLabelType.work,
    );
    final String labelText = _map[FIELD_LABEL_VALUE];
    final dynamic fieldValue = _map[FIELD_TEXT_VALUE];
    return createFieldFunc(
      labelType,
      labelText,
      fieldValue,
    );
  }

  final LabeledFieldLabelType labelType;
  final String labelText;
  final T fieldValue;

  LabeledField(
    this.labelType,
    this.labelText,
    this.fieldValue,
  );

  dynamic fieldValueToJSONConvertable();
}
