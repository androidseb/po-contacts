import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/view/misc/list_items_divider.dart';

abstract class SettingEntry<T> extends StatefulWidget {
  bool shouldDisplay() {
    return true;
  }

  String getLabelText();
  T readCurrentValue();
  writeCurrentValue(final T v);

  @override
  SettingEntryState<T> createState();
}

abstract class SettingEntryState<T> extends State<SettingEntry> {
  bool _firstReadOccured = false;
  T _currentValue;

  T get currentValue {
    if (!_firstReadOccured) {
      _currentValue = widget.readCurrentValue();
      _firstReadOccured = true;
    }
    return _currentValue;
  }

  void setCurrentValue(final T v) {
    widget.writeCurrentValue(v);
    setState(() {
      _currentValue = v;
    });
  }

  Widget buildSettingView(final T v);

  @override
  Widget build(BuildContext context) {
    if (!widget.shouldDisplay()) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        buildSettingView(currentValue),
        ListItemsDivider(),
      ],
    );
  }
}
