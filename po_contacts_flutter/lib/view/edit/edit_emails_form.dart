import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/email_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

class EditEmailsForm extends EditCategorizedItemsForm<EmailInfo> {
  EditEmailsForm(final List<EmailInfo> initialEmailInfos, {final Function(List<EmailInfo> updatedItems) onDataChanged})
      : super(initialEmailInfos, onDataChanged: onDataChanged);

  List<LabeledFieldLabelType> getAllowedLabelTypes() {
    return [LabeledFieldLabelType.work, LabeledFieldLabelType.home, LabeledFieldLabelType.custom];
  }

  @override
  CategorizedEditableItem fromGenericItem(final EmailInfo item) {
    return CategorizedEditableItem(item.textValue, item.labelType, item.labelValue);
  }

  @override
  EmailInfo toGenericItem(final CategorizedEditableItem item) {
    return EmailInfo(item.textValue, item.labelType, item.labelValue);
  }

  @override
  String getEntryHintStringKey() {
    return I18n.string.email;
  }

  @override
  List<TextInputFormatter> getInputFormatters() {
    return null;
  }

  @override
  String getAddEntryActionStringKey() {
    return I18n.string.add_email;
  }
}
