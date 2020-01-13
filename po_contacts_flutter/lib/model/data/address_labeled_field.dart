import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class AddressLabeledField extends LabeledField<AddressInfo> {
  AddressLabeledField(AddressInfo fieldValue, LabeledFieldLabelType labelType, String labelValue)
      : super(fieldValue, labelType, labelValue);
}
