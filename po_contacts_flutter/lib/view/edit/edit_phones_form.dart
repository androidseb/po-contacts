import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_string_items_form.dart';

class EditPhonesForm extends EditCategorizedStringItemsForm {
  EditPhonesForm(final List<StringLabeledField> initialPhoneInfos,
      {final Function(List<StringLabeledField> updatedItems) onDataChanged})
      : super(initialPhoneInfos, onDataChanged: onDataChanged);

  @override
  List<LabeledFieldLabelType> getAllowedLabelTypes() {
    return [
      LabeledFieldLabelType.work,
      LabeledFieldLabelType.home,
      LabeledFieldLabelType.cell,
      LabeledFieldLabelType.fax,
      LabeledFieldLabelType.pager,
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
