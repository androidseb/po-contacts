import 'package:po_contacts_flutter/utils/secure_storage/secure_storage.stub.dart'
    if (dart.library.io) 'package:po_contacts_flutter/utils/secure_storage/secure_storage.mobile.dart'
    if (dart.library.html) 'package:po_contacts_flutter/utils/secure_storage/secure_storage.web.dart';

/// Utility class to store string key/value pairs securely.
/// For mobile, uses flutter_secure_storage.
/// For web, uses cookies, assuming you are using chromium, since cookies are encrypted.
abstract class SecureStorage {
  static SecureStorage? _currentInstance;
  factory SecureStorage() => getInstanceImpl();

  static SecureStorage? get instance {
    if (_currentInstance == null) {
      _currentInstance = getInstanceImpl();
    }
    return _currentInstance;
  }

  Future<void> setValue(final String key, final String? value);

  Future<String?> getValue(final String key);
}
