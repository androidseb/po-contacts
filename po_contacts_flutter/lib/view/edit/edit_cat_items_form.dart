import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/baseuicomponents/poc_button.dart';

class CategorizedEditableItem<T> {
  LabeledFieldLabelType labelType;
  String labelText;
  T fieldValue;

  CategorizedEditableItem(
    this.labelType,
    this.labelText,
    this.fieldValue,
  );
}

class EditableItemCategory {
  LabeledFieldLabelType labelType;
  String labelValue;

  EditableItemCategory(
    this.labelType,
    this.labelValue,
  );

  @override
  int get hashCode => labelType.hashCode + labelValue.hashCode;

  @override
  bool operator ==(final Object o) =>
      o is EditableItemCategory && o.labelType.index == labelType.index && o.labelValue == labelValue;
}

abstract class EditCategorizedItemsForm<F extends LabeledField<T>, T> extends StatefulWidget {
  final List<F> initialItems;
  final Function(List<F> updatedItems) onDataChanged;

  EditCategorizedItemsForm(this.initialItems, {this.onDataChanged});

  EditCategorizedItemsFormState createState() => EditCategorizedItemsFormState<F, T>();

  void notifyDataChanged(final List<CategorizedEditableItem> currentItems) {
    if (onDataChanged == null) {
      return;
    }
    onDataChanged(_toGenericItems(currentItems));
  }

  List<CategorizedEditableItem<T>> fromGenericItems(final List<F> genericItems) {
    if (genericItems == null) {
      return [];
    }
    final List<CategorizedEditableItem<T>> res = [];
    for (final F gi in genericItems) {
      res.add(fromGenericItem(gi));
    }
    return res;
  }

  List<F> _toGenericItems(final List<CategorizedEditableItem<T>> categorizedItems) {
    final List<F> res = [];
    for (final CategorizedEditableItem ci in categorizedItems) {
      res.add(toGenericItem(ci));
    }
    return res;
  }

  List<LabeledFieldLabelType> getAllowedLabelTypes();

  CategorizedEditableItem<T> fromGenericItem(final F item) {
    return CategorizedEditableItem<T>(item.labelType, item.labelText, item.fieldValue);
  }

  F toGenericItem(final CategorizedEditableItem<T> item);

  T getEmptyItemValue();

  String getAddEntryActionStringKey();

  List<Widget> buildDropDownAndDeleteRowWidgets(
    final EditCategorizedItemsFormState<F, T> parentState,
    final BuildContext context,
    final CategorizedEditableItem<T> item,
    final int itemIndex,
  ) {
    return [
      Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 100),
        child: DropdownButton<EditableItemCategory>(
          isExpanded: true,
          value: parentState.getDropDownValue(item),
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          onChanged: (EditableItemCategory newValue) async {
            if (newValue.labelType == LabeledFieldLabelType.CUSTOM && newValue.labelValue.isEmpty) {
              final String customLabelString = await MainController.get().showTextInputDialog(I18n.string.custom_label);
              if (customLabelString == null || customLabelString.isEmpty) {
                return;
              }
              parentState.setItemLabelValue(
                item,
                LabeledFieldLabelType.CUSTOM,
                customLabelString,
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
    ];
  }

  Widget buildWidgetRow(
    final EditCategorizedItemsFormState<F, T> parentState,
    final BuildContext context,
    final CategorizedEditableItem<T> item,
    final int itemIndex,
  );
}

class EditCategorizedItemsFormState<F extends LabeledField<T>, T> extends State<EditCategorizedItemsForm<F, T>> {
  final Set<String> customLabelTypeNames = Set<String>();
  final List<CategorizedEditableItem<T>> currentItems = [];

  static Text dropDownTextWidget(final String text) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<DropdownMenuItem<EditableItemCategory>> getDropDownMenuItems() {
    final List<LabeledFieldLabelType> labelTypes = widget.getAllowedLabelTypes();
    final List<DropdownMenuItem<EditableItemCategory>> res = [];
    for (final LabeledFieldLabelType lt in labelTypes) {
      if (lt == LabeledFieldLabelType.CUSTOM) {
        continue;
      }
      final String labelText = I18n.getString(LabeledField.getTypeNameStringKey(lt));
      res.add(DropdownMenuItem<EditableItemCategory>(
        value: EditableItemCategory(lt, labelText),
        child: dropDownTextWidget(labelText),
      ));
    }
    for (final String customName in customLabelTypeNames) {
      res.add(DropdownMenuItem<EditableItemCategory>(
        value: EditableItemCategory(LabeledFieldLabelType.CUSTOM, customName),
        child: dropDownTextWidget(customName),
      ));
    }
    res.add(DropdownMenuItem<EditableItemCategory>(
      value: EditableItemCategory(LabeledFieldLabelType.CUSTOM, ''),
      child: dropDownTextWidget(I18n.getString(LabeledField.getTypeNameStringKey(LabeledFieldLabelType.CUSTOM))),
    ));
    return res;
  }

  EditableItemCategory getDropDownValue(final CategorizedEditableItem item) {
    if (item.labelType == LabeledFieldLabelType.CUSTOM) {
      return EditableItemCategory(item.labelType, item.labelText);
    } else {
      final String labelText = I18n.getString(LabeledField.getTypeNameStringKey(item.labelType));
      return EditableItemCategory(item.labelType, labelText);
    }
  }

  @override
  void initState() {
    final List<LabeledFieldLabelType> orderedLabelTypes = widget.getAllowedLabelTypes();
    final List<CategorizedEditableItem> editableItems = widget.fromGenericItems(widget.initialItems);
    for (final LabeledFieldLabelType t in orderedLabelTypes) {
      bool addedField = false;
      for (final CategorizedEditableItem cei in editableItems) {
        if (cei.labelType == t) {
          if (cei.labelType == LabeledFieldLabelType.CUSTOM && cei.labelText.isNotEmpty) {
            customLabelTypeNames.add(cei.labelText);
          }
          currentItems.add(cei);
          addedField = true;
        }
      }
      if (t != LabeledFieldLabelType.CUSTOM && !addedField) {
        currentItems.add(CategorizedEditableItem<T>(t, '', widget.getEmptyItemValue()));
      }
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    final List<Widget> widgetRows = [];
    for (int i = 0; i < currentItems.length; i++) {
      final int itemIndex = i;
      final CategorizedEditableItem<T> item = currentItems[itemIndex];
      widgetRows.add(widget.buildWidgetRow(this, context, item, itemIndex));
    }
    widgetRows.add(
      POCButton(
        buttonStyle: POCButtonStyle.FLAT_FILLED,
        textI18nKey: widget.getAddEntryActionStringKey(),
        onPressed: () {
          addEmptyItem();
        },
      ),
    );
    return Column(
      key: Key('${currentItems.length}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetRows,
    );
  }

  void changeItemValue(final CategorizedEditableItem<T> item, T value) {
    setState(() {
      item.fieldValue = value;
      widget.notifyDataChanged(currentItems);
    });
  }

  void setItemLabelValue(
    final CategorizedEditableItem<T> item,
    final LabeledFieldLabelType labelType,
    final String labelValue,
  ) {
    setState(() {
      item.labelType = LabeledFieldLabelType.CUSTOM;
      item.labelText = labelValue;
      customLabelTypeNames.add(labelValue);
      widget.notifyDataChanged(currentItems);
    });
  }

  void removeItemAtIndex(final int itemIndex) {
    setState(() {
      currentItems.removeAt(itemIndex);
      widget.notifyDataChanged(currentItems);
    });
  }

  void addEmptyItem() {
    setState(() {
      currentItems.add(CategorizedEditableItem<T>(
        widget.getAllowedLabelTypes()[0],
        '',
        widget.getEmptyItemValue(),
      ));
    });
  }
}
