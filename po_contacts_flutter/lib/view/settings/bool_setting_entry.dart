import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/view/settings/setting_entry.dart';

abstract class BoolSettingEntry extends SettingEntry<bool> {
  @override
  _BoolSettingEntryState createState() => _BoolSettingEntryState();
}

class _BoolSettingEntryState extends SettingEntryState<bool> {
  @override
  Widget buildSettingView(final bool v) {
    return ListTile(
      leading: Checkbox(
        value: v,
        onChanged: (final bool value) {
          setCurrentValue(value);
        },
      ),
      title: Text(widget.getLabelText()),
    );
  }
}
