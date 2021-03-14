import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:po_contacts_flutter/utils/secure_storage/secure_storage.dart';

class SecureStorageWeb implements SecureStorage {
  final HtmlDocument _htmlDocument = document;

  @override
  Future<String?> getValue(final String key) async {
    final String cookieRawValue = _htmlDocument.cookie!;
    final List<String> cookieRawValues = cookieRawValue.split(';');
    for (final String rawKV in cookieRawValues) {
      final String kv = rawKV.trim();
      final int firstEqualSignIndex = kv.indexOf('=');
      if (firstEqualSignIndex < 0) {
        continue;
      }
      final String k = kv.substring(0, firstEqualSignIndex);
      if (k == key) {
        final String base64Value = kv.substring(firstEqualSignIndex + 1);
        try {
          final Uint8List valueData = base64.decode(base64Value);
          final String textValue = utf8.decode(valueData);
          return textValue;
        } catch (anyException) {
          // Any exception means we can't read the value properly so it should just be ignored
        }
      }
    }
    return null;
  }

  @override
  Future<void> setValue(final String key, final String? value) async {
    final Uint8List valueData = utf8.encode(value!) as Uint8List;
    final String valueBase64 = base64.encode(valueData);
    _htmlDocument.cookie = '$key=$valueBase64; expires=Thu, 18 Dec 2037 12:00:00 UTC';
  }
}

SecureStorage getInstanceImpl() => SecureStorageWeb();
