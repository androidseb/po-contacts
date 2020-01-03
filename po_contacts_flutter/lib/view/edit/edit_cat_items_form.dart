import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
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

abstract class EditCategorizedItemsForm<T> extends StatefulWidget {
  final List<T> initialItems;
  final Function(List<T> updatedItems) onDataChanged;

  EditCategorizedItemsForm(this.initialItems, {this.onDataChanged});

  _EditCategorizedItemsFormState createState() => _EditCategorizedItemsFormState();

  void notifyDataChanged(final List<CategorizedEditableItem> currentItems) {
    if (onDataChanged == null) {
      return;
    }
    onDataChanged(_toGenericItems(currentItems));
  }

  List<CategorizedEditableItem> fromGenericItems(final List<T> genericItems) {
    final List<CategorizedEditableItem> res = [];
    for (final T gi in genericItems) {
      res.add(fromGenericItem(gi));
    }
    return res;
  }

  List<T> _toGenericItems(final List<CategorizedEditableItem> categorizedItems) {
    final List<T> res = [];
    for (final CategorizedEditableItem ci in categorizedItems) {
      res.add(toGenericItem(ci));
    }
    return res;
  }

  List<LabeledFieldLabelType> getAllowedLabelTypes();

  CategorizedEditableItem fromGenericItem(final T item);

  T toGenericItem(final CategorizedEditableItem item);

  String getEntryHintStringKey();

  List<TextInputFormatter> getInputFormatters();

  TextInputType getInputKeyboardType() {
    return TextInputType.text;
  }

  String getAddEntryActionStringKey();
}

class _EditCategorizedItemsFormState extends State<EditCategorizedItemsForm> {
  final List<CategorizedEditableItem> currentItems = [];

  @override
  void initState() {
    if (widget.initialItems != null) {
      currentItems.addAll(widget.fromGenericItems(widget.initialItems));
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
          key: Key('${item.textValue}${item.labelType}${item.labelValue}'),
          children: <Widget>[
            Expanded(
              child: TextFormField(
                initialValue: item.textValue,
                decoration: InputDecoration(
                  labelText: I18n.getString(widget.getEntryHintStringKey()),
                ),
                inputFormatters: widget.getInputFormatters(),
                keyboardType: widget.getInputKeyboardType(),
                validator: (value) {
                  if (value.isEmpty) {
                    return I18n.getString(I18n.string.field_cannot_be_empty);
                  }
                  return null;
                },
                onChanged: (nameValue) {
                  setState(() {
                    item.textValue = nameValue;
                    widget.notifyDataChanged(currentItems);
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
