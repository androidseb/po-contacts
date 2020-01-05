import 'package:po_contacts_flutter/utils/remove_diacritics.dart';

class Utils {
  static String normalizeString(final String sourceString) {
    if (sourceString == null) {
      return '';
    }
    return removeDiacritics(sourceString).toLowerCase();
  }
}
