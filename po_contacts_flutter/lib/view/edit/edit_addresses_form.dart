import 'package:flutter/widgets.dart';
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
    return AddressLabeledField(item.textValue, item.labelType, item.labelValue);
  }

  @override
  AddressInfo getEmptyItemValue() {
    return AddressInfo('', '', '', '', '');
  }

  @override
  Widget buildState(
    final EditCategorizedItemsFormState<AddressLabeledField, AddressInfo> parentState,
    final BuildContext context,
    final List<CategorizedEditableItem<AddressInfo>> currentItems,
  ) {
    //TODO
    return SizedBox.shrink();
  }
}
