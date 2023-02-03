import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
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
      LabeledFieldLabelType.WORK,
      LabeledFieldLabelType.HOME,
      LabeledFieldLabelType.CUSTOM,
    ];
  }

  @override
  AddressLabeledField toGenericItem(final CategorizedEditableItem<AddressInfo> item) {
    return AddressLabeledField(item.labelType, item.labelText, item.fieldValue);
  }

  @override
  AddressInfo getEmptyItemValue() {
    return AddressInfo('', '', '', '', '', '', '');
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
    final bool displayObsoleteAddressFields =
        MainController.get().model.settings.appSettings.displayObsoleteAddressFields;
    final bool shouldDisplayObsoleteAddressFields =
        displayObsoleteAddressFields || itemAddrInfo.postOfficeBox.isNotEmpty || itemAddrInfo.postOfficeBox.isNotEmpty;
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
            shouldDisplayObsoleteAddressFields
                ? TextFormField(
                    initialValue: itemAddrInfo.postOfficeBox,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      labelText: I18n.getString(I18n.string.post_office_box),
                    ),
                    onChanged: (newTextValue) {
                      parentState.changeItemValue(
                        item,
                        AddressInfo(
                          newTextValue,
                          itemAddrInfo.extendedAddress,
                          itemAddrInfo.streetAddress,
                          itemAddrInfo.locality,
                          itemAddrInfo.region,
                          itemAddrInfo.postalCode,
                          itemAddrInfo.country,
                        ),
                      );
                    },
                  )
                : SizedBox.shrink(),
            shouldDisplayObsoleteAddressFields
                ? TextFormField(
                    initialValue: itemAddrInfo.extendedAddress,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: I18n.getString(I18n.string.extended_address),
                    ),
                    onChanged: (newTextValue) {
                      parentState.changeItemValue(
                        item,
                        AddressInfo(
                          itemAddrInfo.postOfficeBox,
                          newTextValue,
                          itemAddrInfo.streetAddress,
                          itemAddrInfo.locality,
                          itemAddrInfo.region,
                          itemAddrInfo.postalCode,
                          itemAddrInfo.country,
                        ),
                      );
                    },
                  )
                : SizedBox.shrink(),
            TextFormField(
              initialValue: itemAddrInfo.streetAddress,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.street_address),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.postOfficeBox,
                    itemAddrInfo.extendedAddress,
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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.locality),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.postOfficeBox,
                    itemAddrInfo.extendedAddress,
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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.region),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.postOfficeBox,
                    itemAddrInfo.extendedAddress,
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
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.postal_code),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.postOfficeBox,
                    itemAddrInfo.extendedAddress,
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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: I18n.getString(I18n.string.country),
              ),
              onChanged: (newTextValue) {
                parentState.changeItemValue(
                  item,
                  AddressInfo(
                    itemAddrInfo.postOfficeBox,
                    itemAddrInfo.extendedAddress,
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
