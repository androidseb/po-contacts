import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_serializer.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

class MockVCFWriter extends VCFWriter {
  final List<String> writtenLines = [];
  @override
  void writeStringImpl(String line) {
    writtenLines.add(line);
  }
}

final Contact testContact1 = Contact(
  0, //id
  '', //image
  'First name', //firstName
  'Last name', //lastName
  'Nickname', //nickName
  'Full Name', //fullName
  [], //phoneInfos
  [], //emailInfos
  [], //addressInfos
  'Organization Name', //organizationName
  'Organization Division', //organizationDivision
  'Organization Title', //organizationTitle
  'www.website.com', //website
  'Notes\nAnd\nmore\nlines', //notes
  [], //unknownVCFFieldLines
);

const String CONTACT1_EXPECTED_OUTPUT = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Full Name\r
N:First name;Last name;;;\r
NICKNAME:Nickname\r
ORG:Organization Name;Organization Division;\r
TITLE:Organization Title\r
URL:www.website.com\r
NOTE:Notes\\nAnd\\nmore\\nlines\r
END:VCARD\r
\r
''';

void main() {
  test('VCF export - empty', () {
    final List<Contact> contacts = [];
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.length, 0);
  });

  test('VCF export - 1 contact', () async {
    final List<Contact> contacts = [];
    contacts.add(testContact1);
    final Function(int progress) progressCallback = (final int progress) {};
    final MockVCFWriter vcfWriter = MockVCFWriter();
    await VCFSerializer.writeToVCF(contacts, vcfWriter, progressCallback);
    expect(vcfWriter.writtenLines.join(), CONTACT1_EXPECTED_OUTPUT);
  });
}
