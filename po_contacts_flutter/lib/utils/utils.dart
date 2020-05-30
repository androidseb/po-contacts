import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

import 'package:po_contacts_flutter/utils/remove_diacritics.dart';

class NormalizedString {
  final String sourceStr;
  String _normalizedStr;

  NormalizedString(this.sourceStr);

  String _getNormalizedStr() {
    if (_normalizedStr == null) {
      _normalizedStr = Utils.normalizeString(sourceStr);
    }
    return _normalizedStr;
  }

  String get normalized => _getNormalizedStr();

  bool contains(final String str) {
    return normalized.contains(str);
  }
}

class Utils {
  /// Releases the current execution thread to allow other queued items to execute
  /// Used when performing heavy operations that don't require multi-threading
  static Future<void> yieldMainQueue() async {
    return Future.delayed(const Duration(milliseconds: 0));
  }

  static String positiveNumberToXDigitsString(final int number, final int digitsCount) {
    return number.toString().padLeft(digitsCount, '0');
  }

  static String normalizeString(final String sourceString) {
    if (sourceString == null) {
      return '';
    }
    return removeDiacritics(sourceString).toLowerCase();
  }

  static int stringCompare(final String str1, final String str2) {
    if (str1 == null && str2 == null) {
      return 0;
    }
    if (str1 == null) {
      return -1;
    }
    if (str2 == null) {
      return -1;
    }
    final String lstr1 = str1.toLowerCase();
    final String lstr2 = str2.toLowerCase();
    final int lCompare = lstr1.compareTo(lstr2);
    if (lCompare == 0) {
      return str1.compareTo(str2);
    } else {
      return lCompare;
    }
  }

  static bool stringEqualsIgnoreCase(final String str1, final String str2) {
    if (str1 == str2) {
      return true;
    }
    if (str1 != null && str2 != null) {
      return str1.toLowerCase() == str2.toLowerCase();
    } else {
      return false;
    }
  }

  static String getFileName(final String filePath) {
    if (filePath == null) {
      return '';
    }
    final List<String> filePathSplit = filePath.split('/');
    return filePathSplit[filePathSplit.length - 1];
  }

  static String getFileExtension(final String filePath) {
    final String fileName = getFileName(filePath);
    if (fileName == null) {
      return '';
    }
    final List<String> pathNameSplit = fileName.split('.');
    return '.' + pathNameSplit[pathNameSplit.length - 1];
  }

  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String strToBase64(final String str) {
    if (str == null) {
      return null;
    }
    final Uint8List strBytes = utf8.encode(str);
    return base64.encode(strBytes);
  }

  static String base64ToString(final String base64String) {
    if (base64String == null) {
      return null;
    }
    final Uint8List strBytes = base64.decode(base64String);
    return utf8.decode(strBytes);
  }

  static bool areUInt8ListsEqual(final Uint8List list1, final Uint8List list2) {
    if (list1 == list2) {
      return true;
    }
    if (list1 == null || list2 == null) {
      return false;
    }
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  static Uint8List combineUInt8Lists(final List<Uint8List> listOfList) {
    return Uint8List.fromList(listOfList.expand((x) => x).toList());
  }

  static String dateTimeToString() {
    final DateTime t = DateTime.now();
    final String monthS = Utils.positiveNumberToXDigitsString(t.month, 2);
    final String dayS = Utils.positiveNumberToXDigitsString(t.day, 2);
    final String hourS = Utils.positiveNumberToXDigitsString(t.hour, 2);
    final String minuteS = Utils.positiveNumberToXDigitsString(t.minute, 2);
    final String secondS = Utils.positiveNumberToXDigitsString(t.second, 2);
    return '${t.year}$monthS${dayS}_$hourS$minuteS$secondS';
  }

  /// Code found on SO: https://stackoverflow.com/a/47870954/3407126
  static String stringToMD5(final String str) {
    final Uint8List strData = new Utf8Encoder().convert(str);
    final crypto.Digest md5Digest = crypto.md5.convert(strData);
    return hex.encode(md5Digest.bytes);
  }
}
