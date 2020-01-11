import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class CategorizedEditableItem {
  String textValue;
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

abstract class EditCategorizedItemsForm extends StatefulWidget {
  final List<LabeledField> initialItems;
  final Function(List<LabeledField> updatedItems) onDataChanged;

  EditCategorizedItemsForm(this.initialItems, {this.onDataChanged});

  _EditCategorizedItemsFormState createState() => _EditCategorizedItemsFormState();

  void notifyDataChanged(final List<CategorizedEditableItem> currentItems) {
    if (onDataChanged == null) {
      return;
    }
    onDataChanged(_toGenericItems(currentItems));
  }

  List<CategorizedEditableItem> fromGenericItems(final List<LabeledField> genericItems) {
    if (genericItems == null) {
      return [];
    }
    final List<CategorizedEditableItem> res = [];
    for (final LabeledField gi in genericItems) {
      res.add(fromGenericItem(gi));
    }
    return res;
  }

  List<LabeledField> _toGenericItems(final List<CategorizedEditableItem> categorizedItems) {
    final List<LabeledField> res = [];
    for (final CategorizedEditableItem ci in categorizedItems) {
      res.add(toGenericItem(ci));
    }
    return res;
  }

  List<LabeledFieldLabelType> getAllowedLabelTypes();

  CategorizedEditableItem fromGenericItem(final LabeledField item) {
    return CategorizedEditableItem(item.textValue, item.labelType, item.labelValue);
  }

  LabeledField toGenericItem(final CategorizedEditableItem item) {
    return LabeledField(item.textValue, item.labelType, item.labelValue);
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
}

class _EditCategorizedItemsFormState extends State<EditCategorizedItemsForm> {
  final Set<String> customLabelTypeNames = Set<String>();
  final List<CategorizedEditableItem> currentItems = [];

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
        currentItems.add(CategorizedEditableItem('', t, ''));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    for (int i = 0; i < currentItems.length; i++) {
      final int itemIndex = i;
      final CategorizedEditableItem item = currentItems[itemIndex];
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                initialValue: item.textValue,
                decoration: InputDecoration(
                  labelText: I18n.getString(widget.getEntryHintStringKey()),
                ),
                inputFormatters: widget.getInputFormatters(),
                keyboardType: widget.getInputKeyboardType(),
                validator: (final String value) {
                  return widget.validateValue(value);
                },
                onChanged: (nameValue) {
                  setState(() {
                    item.textValue = nameValue;
                    widget.notifyDataChanged(currentItems);
                  });
                },
              ),
            ),
            Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 100),
              child: DropdownButton<EditableItemCategory>(
                isExpanded: true,
                value: getDropDownValue(item),
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
                        setState(() {
                          item.labelType = LabeledFieldLabelType.custom;
                          item.labelValue = customLabelString;
                          customLabelTypeNames.add(customLabelString);
                          widget.notifyDataChanged(currentItems);
                        });
                      },
                    );
                    return;
                  }
                  setState(() {
                    item.labelType = newValue.labelType;
                    item.labelValue = newValue.labelValue;
                    widget.notifyDataChanged(currentItems);
                  });
                },
                items: getDropDownMenuItems(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: I18n.getString(I18n.string.remove_entry),
              onPressed: () {
                setState(() {
                  currentItems.removeAt(itemIndex);
                  widget.notifyDataChanged(currentItems);
                });
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
          setState(() {
            currentItems.add(CategorizedEditableItem('', widget.getAllowedLabelTypes()[0], ''));
          });
        },
        child: Text(I18n.getString(widget.getAddEntryActionStringKey())),
      ),
    );
    return Column(
      key: Key('${currentItems.length}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
