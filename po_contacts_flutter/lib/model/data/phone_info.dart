import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class PhoneInfo extends LabeledField {
  PhoneInfo(final String phoneNumber, final LabeledFieldLabelType labelType, final String label)
      : super(LabeledFieldType.phone, phoneNumber, labelType, label);
}
