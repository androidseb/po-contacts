import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/view/misc/multi_selection_choice.dart';
import 'package:po_contacts_flutter/view/settings/setting_entry.dart';

abstract class MultiSelectionEntry extends SettingEntry<int> {
  final List<MultiSelectionChoice> _availableEntries;

  MultiSelectionEntry(this._availableEntries);

  @override
  bool shouldDisplay() {
    return this._availableEntries.length > 1;
  }

  String getEntryDisplayText(final int entryId) {
    for (final MultiSelectionChoice c in _availableEntries) {
      if (c.entryId == entryId) {
        return c.entryLabel;
      }
    }
    return '';
  }

  @override
  _MultiSelectionEntryState createState() => _MultiSelectionEntryState();
}

class _MultiSelectionEntryState extends SettingEntryState<int> {
  @override
  Widget buildSettingView(final int v) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.getLabelText()),
            Text((widget as MultiSelectionEntry).getEntryDisplayText(v)),
          ],
        ),
      ),
      onTap: () {
        onSettingTapped();
      },
    );
  }

  void onSettingTapped() async {
    final MultiSelectionChoice updatedValue = await MainController.get().promptMultiSelection(
      (widget as MultiSelectionEntry).getLabelText(),
      (widget as MultiSelectionEntry)._availableEntries,
    );
    if (updatedValue == null) {
      return;
    }
    setCurrentValue(updatedValue.entryId);
  }
}
