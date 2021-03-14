import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_string_items_form.dart';

class EditEmailsForm extends EditCategorizedStringItemsForm {
  EditEmailsForm(final List<StringLabeledField>? initialEmailInfos,
      {final Function(List<StringLabeledField> updatedItems)? onDataChanged})
      : super(initialEmailInfos, onDataChanged: onDataChanged);

  @override
  List<LabeledFieldLabelType> getAllowedLabelTypes() {
    return [
      LabeledFieldLabelType.WORK,
      LabeledFieldLabelType.HOME,
      LabeledFieldLabelType.CUSTOM,
    ];
  }

  @override
  String getEntryHintStringKey() {
    return I18n.string.email;
  }

  @override
  List<TextInputFormatter> getInputFormatters() {
    return [FilteringTextInputFormatter.allow(RegExp(r'[\@\+\-\.0-9a-zA-Z]'))];
  }

  @override
  String? validateValue(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    bool correctEmail = true;
    final List<String> atSplit = value.split('@');
    if (atSplit.length == 2) {
      final RegExp prefixRegExp = RegExp(r'[\+\-\.0-9a-zA-Z]');
      final RegExp domainRegExp = RegExp(r'[\-\.0-9a-zA-Z]\.[\-\.0-9a-zA-Z]');
      final String prefix = atSplit[0];
      final String domain = atSplit[1];
      correctEmail = prefixRegExp.hasMatch(prefix) && domainRegExp.hasMatch(domain);
    } else {
      correctEmail = false;
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
