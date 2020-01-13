import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class EditAddressesForm extends StatelessWidget {
  final List<LabeledField<AddressInfo>> _initialAddressInfos;

  EditAddressesForm(
    this._initialAddressInfos, {
    final Function(List<LabeledField<AddressInfo>> updatedItems) onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    //TODO
    return SizedBox.shrink();
  }
}
