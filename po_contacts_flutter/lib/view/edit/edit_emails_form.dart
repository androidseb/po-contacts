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
    return [WhitelistingTextInputFormatter(RegExp(r'[\@\+\-\.0-9a-zA-Z]'))];
  }

  @override
  String validateValue(final String value) {
    bool correctEmail = true;
    if (value == null) {
      correctEmail = false;
    } else {
      final List<String> atSplit = value.split('@');
      if (atSplit.length == 2) {
        final RegExp emailCharsRegExp = RegExp(r'[\+\-\.0-9a-zA-Z]');
        correctEmail = emailCharsRegExp.hasMatch(atSplit[0]) && emailCharsRegExp.hasMatch(atSplit[1]);
      } else {
        correctEmail = false;
      }
    }
    if (correctEmail) {
      return null;
    } else {
      return I18n.getString(I18n.string.incorrect_email_address_format);
    }
  }

  @override
  String getAddEntryActionStringKey() {
    return I18n.string.add_email;
  }
}
