import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/view/misc/list_section_header.dart';

class AddressesView extends StatelessWidget {
  final Contact _contact;

  AddressesView(this._contact);

  @override
  Widget build(BuildContext context) {
    if (_contact == null || _contact.addressInfos.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _contact.addressInfos.map(_buildAddressWidget).toList(),
    );
  }

  Widget _buildAddressWidget(final AddressLabeledField addressInfo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListSectionHeader(I18n.getString(
          I18n.string.addresses_with_type_x,
          LabeledField.getLabelTypeDisplayText(addressInfo),
        )),
        Padding(
          padding: EdgeInsets.all(16),
          child: SelectableText(addressInfo.fieldValue.toString()),
        ),
      ],
    );
  }
}
