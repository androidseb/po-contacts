import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';

final Contact testContactSimplest = Contact(
  0, //id
  '', //image
  '', //firstName
  '', //lastName
  '', //nickName
  'Simplest contact full name', //fullName
  //phoneInfos
  [],
  [], //emailInfos
  [], //addressInfos
  '', //organizationName
  '', //organizationDivision
  '', //organizationTitle
  '', //website
  '', //notes
  [], //unknownVCFFieldLines
);

final Contact testContactSimple = Contact(
  0, //id
  '', //image
  'First name Contact 2', //firstName
  'Last name Contact 2', //lastName
  'Nickname Contact 2', //nickName
  'Full Name Contact 2', //fullName
  //phoneInfos
  [],
  [], //emailInfos
  [], //addressInfos
  'Organization Name Contact 2', //organizationName
  'Organization Division Contact 2', //organizationDivision
  'Organization Title Contact 2', //organizationTitle
  'www.website.com Contact 2', //website
  'Notes\nAnd\nmore\nlines Contact 2', //notes
  [], //unknownVCFFieldLines
);

final Contact testContactComplex = Contact(
  0, //id
  '', //image
  'First name', //firstName
  'Last name', //lastName
  'Nickname', //nickName
  'Full Name', //fullName
  //phoneInfos
  [
    StringLabeledField(LabeledFieldLabelType.cell, '', '1234567891'),
    StringLabeledField(LabeledFieldLabelType.work, '', '1234567892'),
    StringLabeledField(LabeledFieldLabelType.home, '', '1234567893'),
    StringLabeledField(LabeledFieldLabelType.fax, '', '1234567894'),
    StringLabeledField(LabeledFieldLabelType.pager, '', '1234567895'),
    StringLabeledField(LabeledFieldLabelType.custom, 'Custom Field Name For Phone', '1234567896'),
  ],
  //emailInfos
  [
    StringLabeledField(LabeledFieldLabelType.cell, '', 'test1@test.com'),
    StringLabeledField(LabeledFieldLabelType.work, '', 'test2@test.com'),
    StringLabeledField(LabeledFieldLabelType.home, '', 'test3@test.com'),
    StringLabeledField(LabeledFieldLabelType.fax, '', 'test4@test.com'),
    StringLabeledField(LabeledFieldLabelType.pager, '', 'test5@test.com'),
    StringLabeledField(LabeledFieldLabelType.custom, 'Custom Field Name For Email', 'test6@test.com'),
  ],
  //addressInfos
  [
    AddressLabeledField(
      LabeledFieldLabelType.home,
      '',
      AddressInfo(
        'Home Street Address String',
        'Home Locality String',
        'Home Region String',
        'Home Postal Code String',
        'Home Country String',
      ),
    ),
    AddressLabeledField(
      LabeledFieldLabelType.work,
      '',
      AddressInfo(
        'Work Street Address String',
        'Work Locality String',
        'Work Region String',
        'Work Postal Code String',
        'Work Country String',
      ),
    ),
    AddressLabeledField(
      LabeledFieldLabelType.custom,
      'Custom Address Field Name',
      AddressInfo(
        'Custom Street Address String',
        'Custom Locality String',
        'Custom Region String',
        'Custom Postal Code String',
        'Custom Country String',
      ),
    ),
  ],
  'Organization Name', //organizationName
  'Organization Division', //organizationDivision
  'Organization Title', //organizationTitle
  'www.website.com', //website
  'Notes\nAnd\nmore\nlines', //notes
  //unknownVCFFieldLines
  [
    'UNKNOWN FIELD LINE 1',
    'UNKNOWN FIELD LINE 2',
    'UNKNOWN FIELD LINE 3',
    'UNKNOWN FIELD LINE 4',
  ],
);

const String CONTACT_SIMPLEST_EXPECTED_OUTPUT = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Simplest contact full name\r
N:;;;;\r
END:VCARD\r
\r
''';

const String CONTACT_SIMPLE_EXPECTED_OUTPUT = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Full Name Contact 2\r
N:First name Contact 2;Last name Contact 2;;;\r
NICKNAME:Nickname Contact 2\r
ORG:Organization Name Contact 2;Organization Division Contact 2;\r
TITLE:Organization Title Contact 2\r
URL:www.website.com Contact 2\r
NOTE:Notes\\nAnd\\nmore\\nlines Contact 2\r
END:VCARD\r
\r
''';

const String CONTACT_COMPLEX_EXPECTED_OUTPUT = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Full Name\r
N:First name;Last name;;;\r
NICKNAME:Nickname\r
ADR;HOME:;;Home Street Address String;Home Locality String;Home Region String;Home Postal Code String;Home Country String\r
ADR;WORK:;;Work Street Address String;Work Locality String;Work Region String;Work Postal Code String;Work Country String\r
ADR;X-Custom Address Field Name:;;Custom Street Address String;Custom Locality String;Custom Region String;Custom Postal Code String;Custom Country String\r
TEL;CELL:1234567891\r
TEL;WORK:1234567892\r
TEL;HOME:1234567893\r
TEL;FAX:1234567894\r
TEL;PAGER:1234567895\r
TEL;X-Custom Field Name For Phone:1234567896\r
EMAIL;CELL:test1@test.com\r
EMAIL;WORK:test2@test.com\r
EMAIL;HOME:test3@test.com\r
EMAIL;FAX:test4@test.com\r
EMAIL;PAGER:test5@test.com\r
EMAIL;X-Custom Field Name For Email:test6@test.com\r
ORG:Organization Name;Organization Division;\r
TITLE:Organization Title\r
URL:www.website.com\r
NOTE:Notes\\nAnd\\nmore\\nlines\r
UNKNOWN FIELD LINE 1\r
UNKNOWN FIELD LINE 2\r
UNKNOWN FIELD LINE 3\r
UNKNOWN FIELD LINE 4\r
END:VCARD\r
\r
''';

const String CONTACTS_MULTIPLE_EXPECTED_OUTPUT =
    CONTACT_SIMPLEST_EXPECTED_OUTPUT + CONTACT_SIMPLE_EXPECTED_OUTPUT + CONTACT_COMPLEX_EXPECTED_OUTPUT;
