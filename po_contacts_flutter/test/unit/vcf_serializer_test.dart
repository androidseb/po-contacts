import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/vcf_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/file_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/tasks_set_progress_callback.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

import 'test_data.dart';

class MockFileReader extends FileReader {
  MockFileReader() : super(null);

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

  @override
  Future<void> flushOutputBuffer({TaskSetProgressCallback progressCallback}) async {}
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

class MockFileEntry extends FileEntity {
  final String absolutePath;
  String base64StringContent = '';

  MockFileEntry(this.absolutePath) {
    MockFileSystem.content[absolutePath] = this;
  }

  @override
  Future<bool> writeAsUint8List(final Uint8List outputData) {
    return writeAsBase64String(base64.encode(outputData));
  }

  Future<bool> writeAsBase64String(String base64String) async {
    base64StringContent += base64String;
    return true;
  }

  String getAbsolutePath() {
    return absolutePath;
  }

  @override
  Future<bool> delete() async {
    MockFileSystem.content[absolutePath] = null;
    return true;
  }

  @override
  Future<FileEntity> create() {
    return null;
  }

  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  void writeAsStringAppendSync(String str) {}

  @override
  Future<List<String>> readAsLines() async {
    return [];
  }

  @override
  Future<String> readAsBase64String() async {
    return null;
  }

  @override
  Future<FileEntity> copy(FileEntity targetFile) {
    return null;
  }

  @override
  Future<void> flushOutputBuffer() async {}
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

void expectStringLabeledFieldsEqual(final List<StringLabeledField> slfl1, final List<StringLabeledField> slfl2) {
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
    expect(slfl1[i].labelType, slfl2[i].labelType);
    expect(slfl1[i].labelText, slfl2[i].labelText);
    expect(slfl1[i].fieldValue, slfl2[i].fieldValue);
  }
}

void expectAddressLabeledFieldsEqual(final List<AddressLabeledField> alfl1, final List<AddressLabeledField> alfl2) {
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
    expect(alfl1[i].labelType, alfl2[i].labelType);
    expect(alfl1[i].labelText, alfl2[i].labelText);
    expect(alfl1[i].fieldValue.streetAddress, alfl2[i].fieldValue.streetAddress);
    expect(alfl1[i].fieldValue.locality, alfl2[i].fieldValue.locality);
    expect(alfl1[i].fieldValue.region, alfl2[i].fieldValue.region);
    expect(alfl1[i].fieldValue.postalCode, alfl2[i].fieldValue.postalCode);
    expect(alfl1[i].fieldValue.country, alfl2[i].fieldValue.country);
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
    final MockVCFWriter vcfWriter = MockVCFWriter();
    VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
    expect(vcfWriter.writtenLines.length, 0);
  });

  test('VCF export - simplest contact', () async {
    final List<Contact> contacts = [testContactSimplest];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
    expect(vcfWriter.writtenLines.join(), CONTACT_SIMPLEST_EXPECTED_OUTPUT);
  });

  test('VCF export - simple contact', () async {
    final List<Contact> contacts = [testContactSimple];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
    expect(vcfWriter.writtenLines.join(), CONTACT_SIMPLE_EXPECTED_OUTPUT);
  });

  test('VCF export - complex contact', () async {
    final List<Contact> contacts = [testContactComplex];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
    expect(vcfWriter.writtenLines.join(), CONTACT_COMPLEX_EXPECTED_OUTPUT);
  });

  test('VCF export - complex contact 2', () async {
    final List<Contact> contacts = [testContactComplex2];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
    expect(vcfWriter.writtenLines.join(), CONTACT_COMPLEX_2_EXPECTED_OUTPUT);
  });

  test('VCF export - multiple contact', () async {
    final List<Contact> contacts = [testContactSimplest, testContactSimple, testContactComplex, testContactComplex2];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      contacts,
      vcfWriter,
    );
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
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactSimplest);
  });

  test('VCF import - simple contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_SIMPLE_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactSimple);
  });

  test('VCF import - complex contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex);
  });

  test('VCF import - complex contact alt1', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_ALTERNATE_INPUT_1));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex);
  });

  test('VCF import - complex contact alt2', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_ALTERNATE_INPUT_2));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex);
  });

  test('VCF import - complex contact alt3', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_ALTERNATE_INPUT_3));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex);
  });

  test('VCF import - complex contact 2', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_2_EXPECTED_OUTPUT));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex2);
  });

  test('VCF import - complex contact 2 alt1', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACT_COMPLEX_2_ALTERNATE_INPUT_1));
    expect(contacts.length, 1);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactComplex2);
  });

  test('VCF import - multiple contact', () async {
    final List<ContactBuilder> contacts =
        await VCFSerializer.readFromVCF(MockVCFReader(CONTACTS_MULTIPLE_EXPECTED_OUTPUT));
    expect(contacts.length, 4);
    expectContactsEqual(ContactBuilder.build(0, contacts[0]), testContactSimplest);
    expectContactsEqual(ContactBuilder.build(0, contacts[1]), testContactSimple);
    expectContactsEqual(ContactBuilder.build(0, contacts[2]), testContactComplex);
    expectContactsEqual(ContactBuilder.build(0, contacts[3]), testContactComplex2);
  });

  test('VCF import of export - consistent data', () async {
    //Export contacts as a string
    final List<Contact> initialContacts = [
      testContactSimplest,
      testContactSimple,
      testContactComplex,
      testContactComplex2
    ];
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(
      initialContacts,
      vcfWriter,
    );
    final String exportResultAsString = vcfWriter.writtenLines.join();

    //Import contacts back from the exported string
    final List<ContactBuilder> importedContacts = await VCFSerializer.readFromVCF(MockVCFReader(exportResultAsString));

    //Test that the imported contacts are identical to the initial contacts
    expect(initialContacts.length, importedContacts.length);
    for (int i = 0; i < initialContacts.length; i++) {
      expectContactsEqual(initialContacts[i], ContactBuilder.build(0, importedContacts[i]));
    }
  });
}
