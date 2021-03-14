import 'package:flutter/material.dart';
import 'package:po_contacts_flutter/assets/i18n.dart';

enum POCButtonStyle {
  FLAT,
  FLAT_FILLED,
  ELEVATED,
}

class POCButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final POCButtonStyle buttonStyle;
  final String? textString;
  final String? textI18nKey;

  POCButton({
    final Key? key,
    this.buttonStyle = POCButtonStyle.FLAT,
    this.onPressed = null,
    this.textString = null,
    this.textI18nKey = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (buttonStyle) {
      case POCButtonStyle.FLAT:
        return buildFlatButton();
      case POCButtonStyle.FLAT_FILLED:
        return buildFlatFilledButton();
      case POCButtonStyle.ELEVATED:
        return buildElevatedButton();
    }
    return buildFlatButton();
  }

  TextButton buildFlatButton() {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      ),
      onPressed: this.onPressed,
      child: createText(),
    );
  }

  TextButton buildFlatFilledButton() {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.green,
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      ),
      onPressed: this.onPressed,
      child: createText(),
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
      ),
      onPressed: this.onPressed,
      child: createText(),
    );
  }

  Text createText() {
    String? resultTextString = '';
    if (textString != null) {
      resultTextString = textString;
    } else if (textI18nKey != null) {
      resultTextString = I18n.getString(this.textI18nKey!);
    }
    return Text(resultTextString!);
  }
}
