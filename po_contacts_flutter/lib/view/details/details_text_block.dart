import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsTextBlock extends StatelessWidget {
  final String text;

  DetailsTextBlock(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SelectableText(text),
    );
  }
}
