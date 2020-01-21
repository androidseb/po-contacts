import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

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
}
