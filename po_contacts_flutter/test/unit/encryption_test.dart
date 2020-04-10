import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/utils/encryption_utils.dart';
import 'package:po_contacts_flutter/utils/utils.dart';
import 'test_data.dart';

const TEST_DATA_SET = [
  '',
  ' ',
  'one',
  'two words',
  'more than 16 bytes of data',
  'more than 32 bytes of data here here',
  CONTACT_COMPLEX_ALTERNATE_INPUT_1,
  CONTACT_COMPLEX_ALTERNATE_INPUT_2,
  CONTACT_COMPLEX_ALTERNATE_INPUT_3,
  CONTACT_COMPLEX_2_ALTERNATE_INPUT_1,
  CONTACT_SIMPLE_EXPECTED_OUTPUT,
  CONTACT_COMPLEX_EXPECTED_OUTPUT,
  CONTACT_SIMPLEST_EXPECTED_OUTPUT,
  CONTACT_SIMPLEST_EXPECTED_OUTPUT,
  CONTACT_COMPLEX_2_EXPECTED_OUTPUT,
  CONTACTS_MULTIPLE_EXPECTED_OUTPUT,
];

const TEST_PASSWORDS_SET = [
  '',
  '123456',
  'password',
  'kiAzbcZ5ZCyvYsonRrQ6gKV3cRVdAei9',
  '1reasonablyHardP@ssw0rdTo\$Crack92018Probably?',
  'pxT,¬j¯ø6Îþf-^øirÀSRÐ{¬òÀT;^%Ïa«KiàÏõnº@ÞXÔ\$ÎF¹{°Ý{~Ç@«këY_\'¼fñ,4ô3¿[ó¤\$Ò¤Ò¶¥Vúªåk´hËãH:¬u5]\'¹ïh§HÆ(ýä.p£GEâWÓóàKøyó·¤`8nåßE)^-+',
];

void main() {
  //ignore: deprecated_member_use_from_same_package
  EncryptionUtils.derivedKeysCache = {};

  test('Encryption modifies the source text', () {
    for (final String plainText in TEST_DATA_SET) {
      for (final String encryptionKey in TEST_PASSWORDS_SET) {
        final Uint8List plainData = utf8.encode(plainText);
        final Uint8List cipherData = EncryptionUtils.encryptText(plainText, encryptionKey);
        expect(Utils.areUInt8ListsEqual(plainData, cipherData), false);
      }
    }
  });

  test('Decryption with the correct password of encrypted data restores the plain text', () {
    for (final String plainText in TEST_DATA_SET) {
      for (final String encryptionKey in TEST_PASSWORDS_SET) {
        final Uint8List cipherData = EncryptionUtils.encryptText(plainText, encryptionKey);
        final String decryptedText = EncryptionUtils.decryptText(cipherData, encryptionKey);
        expect(plainText, decryptedText);
      }
    }
  });

  test('Decryption with the wrong password of encrypted data does not restore the plain text', () {
    for (final String plainText in TEST_DATA_SET) {
      for (final String encryptionKey in TEST_PASSWORDS_SET) {
        final String wrongEncryptionKey = encryptionKey + 'some other string';
        final Uint8List plainTextData = utf8.encode(plainText);
        final Uint8List cipherData = EncryptionUtils.encryptData(plainTextData, encryptionKey);
        final Uint8List decryptedData = EncryptionUtils.decryptData(cipherData, wrongEncryptionKey);
        expect(plainTextData == decryptedData, false);
      }
    }
  });

  test('Encryption is random: different output every time, but same result for decryption', () {
    for (final String plainText in TEST_DATA_SET) {
      for (final String encryptionKey in TEST_PASSWORDS_SET) {
        final Uint8List cipherData = EncryptionUtils.encryptText(plainText, encryptionKey);
        final Uint8List cipherData2 = EncryptionUtils.encryptText(plainText, encryptionKey);
        expect(cipherData == cipherData2, false);
        final Uint8List decryptedData = EncryptionUtils.decryptData(cipherData, encryptionKey);
        final Uint8List decryptedData2 = EncryptionUtils.decryptData(cipherData2, encryptionKey);
        expect(Utils.areUInt8ListsEqual(decryptedData, decryptedData2), true);
      }
    }
  });
}
