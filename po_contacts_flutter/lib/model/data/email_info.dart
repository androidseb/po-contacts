import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class EmailInfo extends LabeledField {
  EmailInfo(final String emailAddress, final LabeledFieldLabelType labelType, final String label)
      : super(LabeledFieldType.email, emailAddress, labelType, label);
}
