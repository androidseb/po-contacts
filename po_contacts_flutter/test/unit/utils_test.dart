import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class MD5TestEntry {
  final String strInput;
  final String expectedOutput;

  const MD5TestEntry({this.strInput, this.expectedOutput});
}

const TEST_DATA_SET = [
  MD5TestEntry(
    strInput: '',
    expectedOutput: 'd41d8cd98f00b204e9800998ecf8427e',
  ),
  MD5TestEntry(
    strInput: 'test',
    expectedOutput: '098f6bcd4621d373cade4e832627b4f6',
  ),
  MD5TestEntry(
    strInput: 'some random short text',
    expectedOutput: 'ec19859432c631e9b67a887971067429',
  ),
  MD5TestEntry(
    strInput: 'some longer text that would exceed the length of the md5 sum',
    expectedOutput: '25978ca15088137d43c75c2cf0c8d746',
  ),
];

void main() {
  test('Can convert a string to md5', () async {
    for (final MD5TestEntry testEntry in TEST_DATA_SET) {
      final String strInput = testEntry.strInput;
      final String expectedOutput = testEntry.expectedOutput;
      final String actualOutput = Utils.stringToMD5(strInput);
      expect(actualOutput, expectedOutput);
    }
  });
}
