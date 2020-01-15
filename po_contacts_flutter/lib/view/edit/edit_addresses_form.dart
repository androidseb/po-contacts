import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/edit/edit_cat_items_form.dart';

class EditAddressesForm extends EditCategorizedItemsForm<AddressLabeledField, AddressInfo> {
  EditAddressesForm(final List<AddressLabeledField> initialAddressInfos,
      {final Function(List<AddressLabeledField> updatedItems) onDataChanged})
      : super(initialAddressInfos, onDataChanged: onDataChanged);

  @override
  List<LabeledFieldLabelType> getAllowedLabelTypes() {
    return [
      LabeledFieldLabelType.work,
      LabeledFieldLabelType.home,
      LabeledFieldLabelType.custom,
    ];
  }

  @override
  AddressLabeledField toGenericItem(final CategorizedEditableItem<AddressInfo> item) {
    return AddressLabeledField(item.labelType, item.labelText, item.fieldValue);
  }

  @override
  AddressInfo getEmptyItemValue() {
    return AddressInfo('', '', '', '', '');
  }

  @override
  String getAddEntryActionStringKey() {
    return I18n.string.add_address;
  }

  @override
  Widget buildWidgetRow(
    final EditCategorizedItemsFormState<AddressLabeledField, AddressInfo> parentState,
    final BuildContext context,
    final CategorizedEditableItem<AddressInfo> item,
    final int itemIndex,
  ) {
    final List<Widget> rowWidgets = [
      Expanded(
        child: Text(
          I18n.getString(I18n.string.address),
        ),
      ),
    ];
    rowWidgets.addAll(buildDropDownAndDeleteRowWidgets(parentState, context, item, itemIndex));
    final AddressInfo itemAddrInfo = item.fieldValue;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: rowWidgets,
            ),
            TextFormField(
              initialValue: itemAddrInfo.streetAddress,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.street_address),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    newTextValue,
                    itemAddrInfo.locality,
                    itemAddrInfo.region,
                    itemAddrInfo.postalCode,
                    itemAddrInfo.country,
                  ),
                );
              },
            ),
            TextFormField(
              initialValue: itemAddrInfo.locality,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.locality),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.streetAddress,
                    newTextValue,
                    itemAddrInfo.region,
                    itemAddrInfo.postalCode,
                    itemAddrInfo.country,
                  ),
                );
              },
            ),
            TextFormField(
              initialValue: itemAddrInfo.region,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.region),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.streetAddress,
                    itemAddrInfo.locality,
                    newTextValue,
                    itemAddrInfo.postalCode,
                    itemAddrInfo.country,
                  ),
                );
              },
            ),
            TextFormField(
              initialValue: itemAddrInfo.postalCode,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.postal_code),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.streetAddress,
                    itemAddrInfo.locality,
                    itemAddrInfo.region,
                    newTextValue,
                    itemAddrInfo.country,
                  ),
                );
              },
            ),
            TextFormField(
              initialValue: itemAddrInfo.country,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.country),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.streetAddress,
                    itemAddrInfo.locality,
                    itemAddrInfo.region,
                    itemAddrInfo.postalCode,
                    newTextValue,
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
