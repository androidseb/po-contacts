import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/abs_file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

import 'test_data.dart';

class MockFileReader extends FileReader {
  @override
  Future<String> fileToBase64String(String filePath) async {
    return MOCK_FILES_BASE64_CONTENT[filePath];
  }
}

class MockVCFWriter extends VCFWriter {
  MockVCFWriter() : super(MockFileReader());

  final List<String> writtenLines = [];
  @override
  void writeStringImpl(String line) {
    writtenLines.add(line);
  }
}

class MockFileSystem {
  static Map<String, MockFileEntry> content = {};

  static String getFileBase64StringContent(final String filePath) {
    if (filePath == null) {
      return null;
    }
    if (MOCK_FILES_BASE64_CONTENT[filePath] != null) {
      return MOCK_FILES_BASE64_CONTENT[filePath];
    }
    if (content[filePath] == null) {
      return null;
    }
    return content[filePath].base64StringContent;
  }
}

class MockFileEntry extends FileEntry {
  final String absolutePath;
  String base64StringContent = '';

  MockFileEntry(this.absolutePath) {
    MockFileSystem.content[absolutePath] = this;
  }

  Future<bool> writeBase64String(String base64String) async {
    base64StringContent += base64String;
    return true;
  }

  String getAbsolutePath() {
    return absolutePath;
  }

  Future<void> delete() async {
    MockFileSystem.content[absolutePath] = null;
  }
}

class MockFileInflater extends FileInflater<MockFileEntry> {
  @override
  Future<MockFileEntry> createNewImageFile(String fileExtension) async {
    return MockFileEntry('${Utils.currentTimeMillis()}$fileExtension}');
  }
}

class MockVCFReader extends VCFReader {
  final String sourceString;
  List<String> lines;
  int currentLine = 0;

  MockVCFReader(this.sourceString) : super(MockFileInflater()) {
    lines = sourceString.split('\r\n');
  }

  @override
  Future<String> readLineImpl() async {
    if (lines == null) {
      return null;
    }
    if (currentLine >= lines.length) {
      return null;
    }
    final String res = lines[currentLine];
    currentLine++;
    return res;
  }
}

expectStringLabeledFieldsEqual(final List<StringLabeledField> slfl1, final List<StringLabeledField> slfl2) {
  if (slfl1 == null) {
    expect(slfl2, null);
    return;
  }
  if (slfl2 == null) {
    expect(slfl1, null);
    return;
  }
  expect(slfl1.length, slfl2.length);
  for (int i = 0; i < slfl1.length; i++) {
    expect(slfl1[i] == slfl2[i], true);
  }
}

expectAddressLabeledFieldsEqual(final List<AddressLabeledField> alfl1, final List<AddressLabeledField> alfl2) {
  if (alfl1 == null) {
    expect(alfl2, null);
    return;
  }
  if (alfl2 == null) {
    expect(alfl1, null);
    return;
  }
  expect(alfl1.length, alfl2.length);
  for (int i = 0; i < alfl1.length; i++) {
    expect(alfl1[i] == alfl2[i], true);
  }
}

void expectContactsEqual(final Contact c1, final Contact c2) {
  expect(c1.id, c2.id);
  expect(MockFileSystem.getFileBase64StringContent(c1.image), MockFileSystem.getFileBase64StringContent(c2.image));
  expect(c1.firstName, c2.firstName);
  expect(c1.lastName, c2.lastName);
  expect(c1.nickName, c2.nickName);
  expect(c1.fullName, c2.fullName);
  expectStringLabeledFieldsEqual(c1.phoneInfos, c2.phoneInfos);
  expectStringLabeledFieldsEqual(c1.emailInfos, c2.emailInfos);
  expectAddressLabeledFieldsEqual(c1.addressInfos, c2.addressInfos);
  expect(c1.organizationName, c2.organizationName);
  expect(c1.organizationDivision, c2.organizationDivision);
  expect(c1.organizationTitle, c2.organizationTitle);
  expect(c1.website, c2.website);
  expect(c1.notes, c2.notes);
  expect(c1.unknownVCFFieldLines, c2.unknownVCFFieldLines);
}

void main() {
  test('VCF export - empty', () {
    final List<Contact> contacts = [];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.length, 0);
  });

  test('VCF export - simplest contact', () async {
    final List<Contact> contacts = [testContactSimplest];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.join(), CONTACT_SIMPLEST_EXPECTED_OUTPUT);
  });

  test('VCF export - simple contact', () async {
    final List<Contact> contacts = [testContactSimple];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.join(), CONTACT_SIMPLE_EXPECTED_OUTPUT);
  });

  test('VCF export - complex contact', () async {
    final List<Contact> contacts = [testContactComplex];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.join(), CONTACT_COMPLEX_EXPECTED_OUTPUT);
  });

  test('VCF export - multiple contact', () async {
    final List<Contact> contacts = [testContactSimplest, testContactSimple, testContactComplex];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.join(), CONTACTS_MULTIPLE_EXPECTED_OUTPUT);
  });

  test('VCF import - empty', () async {
    final List<ContactBuilder> contacts = await VCFSerializer.readFromVCF(MockVCFReader(''));
    expect(contacts.length, 0);
  });

  test('VCF import - simplest contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_SIMPLEST_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(contacts[0].build(0), testContactSimplest);
  });

  test('VCF import - simple contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_SIMPLE_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(contacts[0].build(0), testContactSimple);
  });

  test('VCF import - complex contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(contacts[0].build(0), testContactComplex);
  });

  test('VCF import - multiple contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACTS_MULTIPLE_EXPECTED_OUTPUT));
    expect(contacts.length, 3);
    expectContactsEqual(contacts[0].build(0), testContactSimplest);
    expectContactsEqual(contacts[1].build(0), testContactSimple);
    expectContactsEqual(contacts[2].build(0), testContactComplex);
  });
}
