import 'package:po_contacts_flutter/utils/secure_storage/secure_storage.dart';

SecureStorage getInstanceImpl() =>
    throw UnsupportedError('Cannot create a SecureStorage without dart:html or dart:io.');
