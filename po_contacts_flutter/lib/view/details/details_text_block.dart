import 'package:flutter/material.dart';

class DetailsTextBlock extends StatelessWidget {
  final String text;

  DetailsTextBlock(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SelectableText(text),
    );
  }
}
