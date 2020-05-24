import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

void main() {
  test('LabeledFieldLabelType enum has proper index values', () async {
    for (final LabeledFieldLabelType v in LabeledFieldLabelType.values) {
      switch (v) {
        case LabeledFieldLabelType.CUSTOM:
          expect(v, 0);
          break;
        case LabeledFieldLabelType.WORK:
          expect(v, 1);
          break;
        case LabeledFieldLabelType.HOME:
          expect(v, 2);
          break;
        case LabeledFieldLabelType.CELL:
          expect(v, 3);
          break;
        case LabeledFieldLabelType.FAX:
          expect(v, 4);
          break;
        case LabeledFieldLabelType.PAGER:
          expect(v, 5);
          break;
      }
    }
  });
}
