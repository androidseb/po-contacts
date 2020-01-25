import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

import 'test_data.dart';

class MockVCFWriter extends VCFWriter {
  final List<String> writtenLines = [];
  @override
  void writeStringImpl(String line) {
    writtenLines.add(line);
  }
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
}
