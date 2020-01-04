import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/view/details/details_text_block.dart';
import 'package:po_contacts_flutter/view/misc/list_section_header.dart';

class TitledDetailsTextBlock extends StatelessWidget {
  final String title;
  final String text;

  TitledDetailsTextBlock(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListSectionHeader(this.title),
        DetailsTextBlock(this.text),
      ],
    );
  }
}
