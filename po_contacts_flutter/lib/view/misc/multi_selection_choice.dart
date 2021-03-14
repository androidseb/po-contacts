import 'package:flutter/widgets.dart';

class MultiSelectionChoice {
  final IconData? iconData;
  final int? entryId;
  final String? entryLabel;
  final Function? onSelected;

  const MultiSelectionChoice(
    this.entryLabel, {
    this.entryId,
    this.iconData,
    this.onSelected,
  });
}
