import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class AddressLabeledField extends LabeledField<AddressInfo> {
  AddressLabeledField(final LabeledFieldLabelType labelType, final String labelValue, final AddressInfo fieldValue)
      : super(labelType, labelValue, fieldValue);

  @override
  dynamic fieldValueToJSONConvertable() {
    return fieldValue.toMap();
  }

  static LabeledField createFieldFunc(
    final LabeledFieldLabelType labelType,
    final String labelText,
    final dynamic fieldValue,
  ) {
    return AddressLabeledField(labelType, labelText, AddressInfo.fromMap(fieldValue));
  }
}
