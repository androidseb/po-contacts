import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

void main() {
  test('LabeledFieldLabelType enum has proper index values', () async {
    for (final LabeledFieldLabelType v in LabeledFieldLabelType.values) {
      switch (v) {
        case LabeledFieldLabelType.custom:
          expect(v, 0);
          break;
        case LabeledFieldLabelType.work:
          expect(v, 1);
          break;
        case LabeledFieldLabelType.home:
          expect(v, 2);
          break;
        case LabeledFieldLabelType.cell:
          expect(v, 3);
          break;
        case LabeledFieldLabelType.fax:
          expect(v, 4);
          break;
        case LabeledFieldLabelType.pager:
          expect(v, 5);
          break;
      }
    }
  });
}
