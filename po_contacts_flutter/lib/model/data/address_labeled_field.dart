import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class AddressLabeledField extends LabeledField<AddressInfo?> {
  AddressLabeledField(final LabeledFieldLabelType? labelType, final String? labelValue, final AddressInfo? fieldValue)
      : super(labelType, labelValue, fieldValue);

  @override
  dynamic fieldValueToJSONConvertable() {
    return fieldValue!.toMap();
  }

  static LabeledField createFieldFunc(
    final LabeledFieldLabelType? labelType,
    final String? labelText,
    final dynamic fieldValue,
  ) {
    return AddressLabeledField(labelType, labelText, AddressInfo.fromMap(fieldValue));
  }

  static bool areEqual(final AddressLabeledField item1, final AddressLabeledField item2) {
    if (item1 == item2) {
      return true;
    }
    if (item1 == null || item2 == null) {
      return false;
    }
    if (item1.labelType != item2.labelType) return false;
    if (item1.labelText != item2.labelText) return false;
    if (!AddressInfo.areEqual(item1.fieldValue, item2.fieldValue)) return false;
    return true;
  }
}
