import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

abstract class EditCategorizedStringItemsForm extends EditCategorizedItemsForm<StringLabeledField, String> {
  EditCategorizedStringItemsForm(final List<StringLabeledField>? initialItems,
      {final Function(List<StringLabeledField> updatedItems)? onDataChanged})
      : super(initialItems, onDataChanged: onDataChanged);

  @override
  StringLabeledField toGenericItem(final CategorizedEditableItem<String?> item) {
    return StringLabeledField(item.labelType, item.labelText, item.fieldValue);
  }

  String getEntryHintStringKey();

  List<TextInputFormatter> getInputFormatters();

  TextInputType getInputKeyboardType() {
    return TextInputType.text;
  }

  String? validateValue(final String? value) {
    return null;
  }

  @override
  String getEmptyItemValue() {
    return '';
  }

  @override
  Widget buildWidgetRow(
    final EditCategorizedItemsFormState<StringLabeledField, String> parentState,
    final BuildContext context,
    final CategorizedEditableItem<String> item,
    final int itemIndex,
  ) {
    final List<Widget> rowWidgets = [
      Expanded(
        child: TextFormField(
          initialValue: item.fieldValue,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: I18n.getString(getEntryHintStringKey()),
          ),
          inputFormatters: getInputFormatters(),
          keyboardType: getInputKeyboardType(),
          validator: (final String? value) {
            return validateValue(value);
          },
          onChanged: (nameValue) {
            parentState.changeItemValue(item, nameValue);
          },
        ),
      ),
    ];
    rowWidgets.addAll(buildDropDownAndDeleteRowWidgets(parentState, context, item, itemIndex));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowWidgets,
    );
  }
}
