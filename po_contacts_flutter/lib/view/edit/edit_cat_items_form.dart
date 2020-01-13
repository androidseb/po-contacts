import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class CategorizedEditableItem<T> {
  T textValue;
  LabeledFieldLabelType labelType;
  String labelValue;

  CategorizedEditableItem(
    this.textValue,
    this.labelType,
    this.labelValue,
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
  bool operator ==(o) =>
      o is EditableItemCategory && o.labelType.index == labelType.index && o.labelValue == labelValue;
}

abstract class EditCategorizedItemsForm<F extends LabeledField, T> extends StatefulWidget {
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
    return CategorizedEditableItem<T>(item.fieldValue, item.labelType, item.labelValue);
  }

  F toGenericItem(final CategorizedEditableItem<T> item);

  T getEmptyItemValue();

  Widget buildState(
    final EditCategorizedItemsFormState<F, T> parentState,
    final BuildContext context,
    final List<CategorizedEditableItem<T>> currentItems,
  );
}

class EditCategorizedItemsFormState<F extends LabeledField, T> extends State<EditCategorizedItemsForm<F, T>> {
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
      if (lt == LabeledFieldLabelType.custom) {
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
        value: EditableItemCategory(LabeledFieldLabelType.custom, customName),
        child: dropDownTextWidget(customName),
      ));
    }
    res.add(DropdownMenuItem<EditableItemCategory>(
      value: EditableItemCategory(LabeledFieldLabelType.custom, ''),
      child: dropDownTextWidget(I18n.getString(LabeledField.getTypeNameStringKey(LabeledFieldLabelType.custom))),
    ));
    return res;
  }

  EditableItemCategory getDropDownValue(final CategorizedEditableItem item) {
    if (item.labelType == LabeledFieldLabelType.custom) {
      return EditableItemCategory(item.labelType, item.labelValue);
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
          if (cei.labelType == LabeledFieldLabelType.custom && cei.labelValue.isNotEmpty) {
            customLabelTypeNames.add(cei.labelValue);
          }
          currentItems.add(cei);
          addedField = true;
        }
      }
      if (!addedField) {
        currentItems.add(CategorizedEditableItem<T>(widget.getEmptyItemValue(), t, ''));
      }
    }
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return widget.buildState(this, context, currentItems);
  }

  void changeItemValue(final CategorizedEditableItem<T> item, T value) {
    setState(() {
      item.textValue = value;
      widget.notifyDataChanged(currentItems);
    });
  }

  void setItemLabelValue(
    final CategorizedEditableItem<String> item,
    final LabeledFieldLabelType labelType,
    final String labelValue,
  ) {
    setState(() {
      item.labelType = LabeledFieldLabelType.custom;
      item.labelValue = labelValue;
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
        widget.getEmptyItemValue(),
        widget.getAllowedLabelTypes()[0],
        '',
      ));
    });
  }
}
