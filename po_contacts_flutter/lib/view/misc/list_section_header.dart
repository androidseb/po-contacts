import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/controller/main_controller.dart';
import 'package:po_contacts_flutter/po_constants.dart';

class ListSectionHeader extends StatelessWidget {
  final String titleString;

  ListSectionHeader(this.titleString) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Container(
        height: POConstants.LIST_SECTION_DEFAULT_HEIGHT,
        decoration: BoxDecoration(
            color: MainController.get().model.settings.appSettings.currentValue.useDarkDisplay
                ? Colors.green[900]
                : Colors.lightGreen[100]),
        child: Center(
          child: Text(
            titleString,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
