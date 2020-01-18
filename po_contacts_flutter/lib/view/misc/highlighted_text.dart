import 'package:flutter/widgets.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class HighlightedText extends StatelessWidget {
  final String fullText;
  final String highlightedText;

  HighlightedText(this.fullText, this.highlightedText);

  @override
  Widget build(BuildContext context) {
    final String nFullText = Utils.normalizeString(fullText);
    final String nHText = Utils.normalizeString(highlightedText);
    final int htIndex = nFullText.indexOf(nHText);
    String finalPreText = '';
    String finalHText = '';
    String finalPostText = '';
    if (htIndex == -1) {
      finalPreText = nFullText;
    } else {
      finalPreText = nFullText.substring(0, htIndex);
      finalHText = nFullText.substring(htIndex, htIndex + nHText.length);
      finalPostText = nFullText.substring(htIndex + nHText.length);
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: '$finalPreText'),
          TextSpan(text: '$finalHText', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' $finalPostText'),
        ],
      ),
    );
  }
}
