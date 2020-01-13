import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

abstract class EditCategorizedStringItemsForm extends EditCategorizedItemsForm<StringLabeledField, String> {
  EditCategorizedStringItemsForm(final List<StringLabeledField> initialItems,
      {final Function(List<StringLabeledField> updatedItems) onDataChanged})
      : super(initialItems, onDataChanged: onDataChanged);

  @override
  StringLabeledField toGenericItem(final CategorizedEditableItem<String> item) {
    return StringLabeledField(item.textValue, item.labelType, item.labelValue);
  }

  String getEntryHintStringKey();

  List<TextInputFormatter> getInputFormatters();

  TextInputType getInputKeyboardType() {
    return TextInputType.text;
  }

  String validateValue(final String value) {
    return null;
  }

  String getAddEntryActionStringKey();

  @override
  String getEmptyItemValue() {
    return '';
  }

  @override
  Widget buildState(
    final EditCategorizedItemsFormState<StringLabeledField, String> parentState,
    final BuildContext context,
    final List<CategorizedEditableItem<String>> currentItems,
  ) {
    final List<Widget> rows = [];
    for (int i = 0; i < currentItems.length; i++) {
      final int itemIndex = i;
      final CategorizedEditableItem<String> item = currentItems[itemIndex];
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                initialValue: item.textValue,
                decoration: InputDecoration(
                  labelText: I18n.getString(getEntryHintStringKey()),
                ),
                inputFormatters: getInputFormatters(),
                keyboardType: getInputKeyboardType(),
                validator: (final String value) {
                  return validateValue(value);
                },
                onChanged: (nameValue) {
                  parentState.changeItemValue(item, nameValue);
                },
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 100),
              child: DropdownButton<EditableItemCategory>(
                isExpanded: true,
                value: parentState.getDropDownValue(item),
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                onChanged: (EditableItemCategory newValue) {
                  if (newValue.labelType == LabeledFieldLabelType.custom && newValue.labelValue.isEmpty) {
                    MainController.get().showTextInputDialog(
                      I18n.string.custom_label,
                      (final String customLabelString) {
                        if (customLabelString == null || customLabelString.isEmpty) {
                          return;
                        }
                        parentState.setItemLabelValue(
                          item,
                          LabeledFieldLabelType.custom,
                          customLabelString,
                        );
                      },
                    );
                    return;
                  }
                  parentState.setItemLabelValue(
                    item,
                    newValue.labelType,
                    newValue.labelValue,
                  );
                },
                items: parentState.getDropDownMenuItems(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: I18n.getString(I18n.string.remove_entry),
              onPressed: () {
                parentState.removeItemAtIndex(itemIndex);
              },
            ),
          ],
        ),
      );
    }
    rows.add(
      FlatButton(
        color: Colors.green,
        textColor: Colors.white,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.greenAccent,
        onPressed: () {
          parentState.addEmptyItem();
        },
        child: Text(I18n.getString(getAddEntryActionStringKey())),
      ),
    );
    return Column(
      key: Key('${currentItems.length}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
