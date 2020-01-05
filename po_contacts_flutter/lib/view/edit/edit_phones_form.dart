import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

class EditPhonesForm extends EditCategorizedItemsForm {
  EditPhonesForm(final List<LabeledField> initialPhoneInfos,
      {final Function(List<LabeledField> updatedItems) onDataChanged})
      : super(initialPhoneInfos, onDataChanged: onDataChanged);

  List<LabeledFieldLabelType> getAllowedLabelTypes() {
    return [
      LabeledFieldLabelType.work,
      LabeledFieldLabelType.home,
      LabeledFieldLabelType.cell,
      LabeledFieldLabelType.custom
    ];
  }

  @override
  String getEntryHintStringKey() {
    return I18n.string.phone;
  }

  @override
  String getAddEntryActionStringKey() {
    return I18n.string.add_phone;
  }

  @override
  List<TextInputFormatter> getInputFormatters() {
    return [WhitelistingTextInputFormatter(RegExp(r'[\+\-\ 0-9]'))];
  }

  TextInputType getInputKeyboardType() {
    return TextInputType.phone;
  }
}
