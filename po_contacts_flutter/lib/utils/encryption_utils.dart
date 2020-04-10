import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:po_contacts_flutter/utils/utils.dart';
import "package:pointycastle/export.dart";

/// Utility class to handle encryption
/// Mostly based on code found here:
/// https://github.com/bcgit/pc-dart/tree/master/tutorials
class EncryptionUtils {
  /// DO NOT USE THIS VARIABLE OUTSIDE OF AUTOMATED TESTS
  /// If that variable is initialized to something else than null
  /// it will be used to cache a mapping of password => derived key.
  /// This variable is only meant to be used by tests to avoid the
  /// high computing cost of deriving keys, but it should NEVER be used
  /// in user-facing code since we want to avoid storing sensitive information
  /// in memory as much as possible.
  @deprecated
  static Map<String, Uint8List> derivedKeysCache;

  /// The number of bytes in an AES block (IV or encrypted block size)
  static const _AES_BLOCK_BYTES_COUNT = 16;
  static const _DIGEST_ITERATIONS_COUNT = 100000;

  /// Generates a random initialization vector ready to use for encryption
  static Uint8List _generateRandomIV() {
    final Random random = Random.secure();
    final List<int> ivBytes = List<int>.generate(_AES_BLOCK_BYTES_COUNT, (i) => random.nextInt(256));
    return Uint8List.fromList(ivBytes);
  }

  /// Derives a plain encryption key to make it ready for encryption
  /// Applies the SHA256 digest quite a few times
  static Uint8List _deriveKey(final String plainKey) {
    //ignore: deprecated_member_use_from_same_package
    if (derivedKeysCache != null) {
      //ignore: deprecated_member_use_from_same_package
      final Uint8List cachedDerivedKey = derivedKeysCache[plainKey];
      if (cachedDerivedKey != null) {
        return cachedDerivedKey;
      }
    }
    final Uint8List dataToDigest = utf8.encode(plainKey);
    final SHA256Digest d = SHA256Digest();
    Uint8List digestedData = dataToDigest;
    for (int i = 0; i < _DIGEST_ITERATIONS_COUNT; i++) {
      digestedData = d.process(dataToDigest);
    }
    //ignore: deprecated_member_use_from_same_package
    if (derivedKeysCache != null) {
      //ignore: deprecated_member_use_from_same_package
      derivedKeysCache[plainKey] = digestedData;
    }
    return digestedData;
  }

  static Uint8List _padData(final Uint8List _data) {
    final int numberOfCharsToPad = _AES_BLOCK_BYTES_COUNT - (_data.length % _AES_BLOCK_BYTES_COUNT);
    final Uint8List paddingText = utf8.encode('\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0');
    return Utils.combineUint8Lists(_data, paddingText.sublist(0, numberOfCharsToPad));
  }

  static Uint8List _unPadData(final Uint8List _data) {
    final int paddingChar = utf8.encode('\0')[0];
    int numberOfPaddingCharsToRemove = 0;
    for (int i = _data.length - 1; i > _data.length - 1 - _AES_BLOCK_BYTES_COUNT; i--) {
      if (_data[i] == paddingChar) {
        numberOfPaddingCharsToRemove++;
      } else {
        break;
      }
    }
    return _data.sublist(0, _data.length - numberOfPaddingCharsToRemove);
  }

  static Uint8List _aesCbcEncrypt(final Uint8List key, Uint8List iv, final Uint8List paddedPlaintext) {
    // Create a CBC block cipher with AES, and initialize with key and IV
    final cbc = CBCBlockCipher(AESFastEngine())..init(true, ParametersWithIV(KeyParameter(key), iv)); // true=encrypt

    // Encrypt the plaintext block-by-block
    final cipherText = Uint8List(paddedPlaintext.length); // allocate space

    var offset = 0;
    while (offset < paddedPlaintext.length) {
      offset += cbc.processBlock(paddedPlaintext, offset, cipherText, offset);
    }
    assert(offset == paddedPlaintext.length);

    return cipherText;
  }

  static Uint8List _aesCbcDecrypt(final Uint8List key, final Uint8List iv, final Uint8List cipherText) {
    // Create a CBC block cipher with AES, and initialize with key and IV
    final cbc = CBCBlockCipher(AESFastEngine())..init(false, ParametersWithIV(KeyParameter(key), iv)); // false=decrypt

    // Decrypt the cipherText block-by-block
    final paddedPlainText = Uint8List(cipherText.length); // allocate space

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);

    return paddedPlainText;
  }

  static Uint8List encryptText(final String plainText, final String encryptionKey) {
    final Uint8List plainTextData = utf8.encode(plainText);
    return encryptData(plainTextData, encryptionKey);
  }

  static Uint8List encryptData(final Uint8List plainData, final String encryptionKey) {
    final Uint8List iv = _generateRandomIV();
    final Uint8List derivedKey = _deriveKey(encryptionKey);
    final Uint8List paddedPlainTextData = _padData(plainData);
    final Uint8List encryptedBytes = _aesCbcEncrypt(derivedKey, iv, paddedPlainTextData);
    return Utils.combineUint8Lists(iv, encryptedBytes);
  }

  static String decryptText(final Uint8List cipherData, final String encryptionKey) {
    return utf8.decode(decryptData(cipherData, encryptionKey));
  }

  static Uint8List decryptData(final Uint8List cipherData, final String encryptionKey) {
    // If there isn't at least 2 AES blocks (IV block + at least one data block), we give up here
    if (cipherData.length < _AES_BLOCK_BYTES_COUNT * 2) {
      throw Exception('Cipher data is too short');
    }
    // If the block data size is not a multiple of _AES_BLOCK_BYTES_COUNT, we give up here
    if (cipherData.length % _AES_BLOCK_BYTES_COUNT != 0) {
      throw Exception('Cipher data length is not a multiple of the AES block size of ($_AES_BLOCK_BYTES_COUNT)');
    }
    final Uint8List derivedKey = _deriveKey(encryptionKey);
    final Uint8List iv = cipherData.sublist(0, _AES_BLOCK_BYTES_COUNT);
    final Uint8List cipherDataBytes = cipherData.sublist(_AES_BLOCK_BYTES_COUNT);
    final Uint8List decryptedBytes = _aesCbcDecrypt(derivedKey, iv, cipherDataBytes);
    final Uint8List unPaddedData = _unPadData(decryptedBytes);
    return unPaddedData;
  }
}
