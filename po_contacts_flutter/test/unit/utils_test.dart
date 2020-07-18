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

void testAreListsEqual(
  final List<String> list1,
  final List<String> list2,
  bool equalsFunction(final String a, final String b),
  bool expectedResult,
) {
  expect(Utils.areListsEqual(list1, list2, equalsFunction: equalsFunction), expectedResult);
}

void main() {
  test('Can convert a string to md5', () async {
    for (final MD5TestEntry testEntry in TEST_DATA_SET) {
      final String strInput = testEntry.strInput;
      final String expectedOutput = testEntry.expectedOutput;
      final String actualOutput = Utils.stringToMD5(strInput);
      expect(actualOutput, expectedOutput);
    }
  });

  test('Can check lists equality with Utils.areListsEqual', () async {
    final neverEqualsFunction = (final String a, final String b) {
      return false;
    };
    final alwaysEqualsFunction = (final String a, final String b) {
      return true;
    };
    final invertEqualsFunction = (final String a, final String b) {
      return a != b;
    };

    testAreListsEqual([''], [''], null, true);
    testAreListsEqual([''], [''], neverEqualsFunction, false);
    testAreListsEqual([''], [''], alwaysEqualsFunction, true);
    testAreListsEqual([''], [''], invertEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c'], null, true);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c'], neverEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c'], alwaysEqualsFunction, true);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c'], invertEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c'], null, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c'], neverEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c'], alwaysEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c'], invertEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c', 'd'], null, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c', 'd'], neverEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c', 'd'], alwaysEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c'], ['a', 'b', 'c', 'd'], invertEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c', 'd2'], null, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c', 'd2'], neverEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c', 'd2'], alwaysEqualsFunction, true);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a', 'b', 'c', 'd2'], invertEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a2', 'b2', 'c2', 'd2'], null, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a2', 'b2', 'c2', 'd2'], neverEqualsFunction, false);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a2', 'b2', 'c2', 'd2'], alwaysEqualsFunction, true);
    testAreListsEqual(['a', 'b', 'c', 'd'], ['a2', 'b2', 'c2', 'd2'], invertEqualsFunction, true);
    testAreListsEqual(<String>[], ['a', 'b', 'c', 'd'], null, false);
    testAreListsEqual(<String>[], ['a', 'b', 'c', 'd'], neverEqualsFunction, false);
    testAreListsEqual(<String>[], ['a', 'b', 'c', 'd'], alwaysEqualsFunction, false);
    testAreListsEqual(<String>[], ['a', 'b', 'c', 'd'], invertEqualsFunction, false);
  });
}
