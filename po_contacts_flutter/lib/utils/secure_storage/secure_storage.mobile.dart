import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:po_contacts_flutter/utils/secure_storage/secure_storage.dart';

class SecureStorageMobile implements SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<String?> getValue(final String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> setValue(final String key, final String value) {
    return _storage.write(key: key, value: value);
  }
}

SecureStorage getInstanceImpl() => SecureStorageMobile();
