import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/phone_info.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

class EditPhonesForm extends EditCategorizedItemsForm<PhoneInfo> {
  EditPhonesForm(final List<PhoneInfo> initialPhoneInfos, {final Function(List<PhoneInfo> updatedItems) onDataChanged})
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
  CategorizedEditableItem fromGenericItem(final PhoneInfo item) {
    return CategorizedEditableItem(item.textValue, item.labelType, item.labelValue);
  }

  @override
  PhoneInfo toGenericItem(final CategorizedEditableItem item) {
    return PhoneInfo(item.textValue, item.labelType, item.labelValue);
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
