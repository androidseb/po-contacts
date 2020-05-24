import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';

const String specialCharsBase = ' ; & \\ : * & \' " . \t ~ @ ç';
const String specialCharsEscaped = ' \\; & \\\\ \\: * & \' " . \t ~ @ ç';
const String specialCharsBadlyEscaped = ' \\; & \\ \\: * & \' " . \t ~ @ ç';
const String specialCharsWorstlyEscaped = ' ; & \\ : * & \' " . \t ~ @ ç';

final Contact testContactSimplest = Contact(
  0, //id
  null, //image
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
  null, //image
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
  'test/file/path/1.jpg', //image
  'First name', //firstName
  'Last name', //lastName
  'Nickname', //nickName
  'Full Name', //fullName
  //phoneInfos
  [
    StringLabeledField(LabeledFieldLabelType.CUSTOM, 'Custom Field Name For Phone', '1234567896'),
    StringLabeledField(LabeledFieldLabelType.WORK, '', '1234567892'),
    StringLabeledField(LabeledFieldLabelType.HOME, '', '1234567893'),
    StringLabeledField(LabeledFieldLabelType.CELL, '', '1234567891'),
    StringLabeledField(LabeledFieldLabelType.FAX, '', '1234567894'),
    StringLabeledField(LabeledFieldLabelType.PAGER, '', '1234567895'),
  ],
  //emailInfos
  [
    StringLabeledField(LabeledFieldLabelType.CUSTOM, 'Custom Field Name For Email', 'test6@test.com'),
    StringLabeledField(LabeledFieldLabelType.WORK, '', 'test2@test.com'),
    StringLabeledField(LabeledFieldLabelType.HOME, '', 'test3@test.com'),
    StringLabeledField(LabeledFieldLabelType.CELL, '', 'test1@test.com'),
    StringLabeledField(LabeledFieldLabelType.FAX, '', 'test4@test.com'),
    StringLabeledField(LabeledFieldLabelType.PAGER, '', 'test5@test.com'),
  ],
  //addressInfos
  [
    AddressLabeledField(
      LabeledFieldLabelType.CUSTOM,
      'Custom Address Field Name',
      AddressInfo(
        'Custom Street Address String',
        'Custom Locality String',
        'Custom Region String',
        'Custom Postal Code String',
        'Custom Country String',
      ),
    ),
    AddressLabeledField(
      LabeledFieldLabelType.WORK,
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
      LabeledFieldLabelType.HOME,
      '',
      AddressInfo(
        'Home Street Address String',
        'Home Locality String',
        'Home Region String',
        'Home Postal Code String',
        'Home Country String',
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

final Contact testContactComplex2 = Contact(
  0, //id
  null, //image
  'First name $specialCharsBase', //firstName
  'Last name $specialCharsBase', //lastName
  'Nickname $specialCharsBase', //nickName
  'Full Name $specialCharsBase', //fullName
  //phoneInfos
  [
    StringLabeledField(LabeledFieldLabelType.CUSTOM, 'Custom Field Name For Phone $specialCharsBase',
        '1234567896 $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.WORK, '', '1234567892 $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.HOME, '', '1234567893 $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.CELL, '', '1234567891 $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.FAX, '', '1234567894 $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.PAGER, '', '1234567895 $specialCharsBase'),
  ],
  //emailInfos
  [
    StringLabeledField(LabeledFieldLabelType.CUSTOM, 'Custom Field Name For Email $specialCharsBase',
        'test6@test.com $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.WORK, '', 'test2@test.com $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.HOME, '', 'test3@test.com $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.CELL, '', 'test1@test.com $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.FAX, '', 'test4@test.com $specialCharsBase'),
    StringLabeledField(LabeledFieldLabelType.PAGER, '', 'test5@test.com $specialCharsBase'),
  ],
  //addressInfos
  [
    AddressLabeledField(
      LabeledFieldLabelType.CUSTOM,
      'Custom Address Field Name $specialCharsBase',
      AddressInfo(
        'Custom Street Address String $specialCharsBase',
        'Custom Locality String $specialCharsBase',
        'Custom Region String $specialCharsBase',
        'Custom Postal Code String $specialCharsBase',
        'Custom Country String $specialCharsBase',
      ),
    ),
    AddressLabeledField(
      LabeledFieldLabelType.WORK,
      '',
      AddressInfo(
        'Work Street Address String $specialCharsBase',
        'Work Locality String $specialCharsBase',
        'Work Region String $specialCharsBase',
        'Work Postal Code String $specialCharsBase',
        'Work Country String $specialCharsBase',
      ),
    ),
    AddressLabeledField(
      LabeledFieldLabelType.HOME,
      '',
      AddressInfo(
        'Home Street Address String $specialCharsBase',
        'Home Locality String $specialCharsBase',
        'Home Region String $specialCharsBase',
        'Home Postal Code String $specialCharsBase',
        'Home Country String $specialCharsBase',
      ),
    ),
  ],
  'Organization Name $specialCharsBase', //organizationName
  'Organization Division $specialCharsBase', //organizationDivision
  'Organization Title $specialCharsBase', //organizationTitle
  'www.website.com $specialCharsBase', //website
  'Notes\nAnd\nmore\nlines $specialCharsBase', //notes
  //unknownVCFFieldLines
  [
    'UNKNOWN FIELD LINE 1 $specialCharsBase',
    'UNKNOWN FIELD LINE 2 $specialCharsBase',
    'UNKNOWN FIELD LINE 3 $specialCharsBase',
    'UNKNOWN FIELD LINE 4 $specialCharsBase',
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
N:Last name Contact 2;First name Contact 2;;;\r
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
PHOTO;ENCODING=BASE64;JPEG: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\r
FN:Full Name\r
N:Last name;First name;;;\r
NICKNAME:Nickname\r
ADR;X-Custom Address Field Name:;;Custom Street Address String;Custom Locality String;Custom Region String;Custom Postal Code String;Custom Country String\r
ADR;WORK:;;Work Street Address String;Work Locality String;Work Region String;Work Postal Code String;Work Country String\r
ADR;HOME:;;Home Street Address String;Home Locality String;Home Region String;Home Postal Code String;Home Country String\r
TEL;X-Custom Field Name For Phone:1234567896\r
TEL;WORK:1234567892\r
TEL;HOME:1234567893\r
TEL;CELL:1234567891\r
TEL;FAX:1234567894\r
TEL;PAGER:1234567895\r
EMAIL;X-Custom Field Name For Email:test6@test.com\r
EMAIL;WORK:test2@test.com\r
EMAIL;HOME:test3@test.com\r
EMAIL;CELL:test1@test.com\r
EMAIL;FAX:test4@test.com\r
EMAIL;PAGER:test5@test.com\r
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

//Alternative input string to "complex contact" (same imported data, but different input string)
//This one has random line breaks in the middle of fields or in between fields
const String CONTACT_COMPLEX_ALTERNATE_INPUT_1 = '''BEGIN:VCARD\r
VERSION:2.1\r
PHOTO;ENCODING=BASE64;JPEG:/9j/4AAQSkZ\r
 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\r
FN:Full\r
  Name\r
N:Last\r
  name;First \r
 name;;;\r
NICKNAME:Nickname\r
\r
\r
ADR;X-Custom Address Field \r
 Name:;;Custom Street Addre\r
 ss String;Custom Locality String;Custom Region String;Custom Pos\r
 tal Code String;Custom Country String\r
\r
\r
\r
ADR;WORK:;;Work Street Address String;Work Locality String;Work Region String;Work Postal Code String;Work Country String\r
\r
ADR;HOME:;;Home Street Address String;\r
 Home Locality String;Home Region String;Home Postal Code String;Home Country String\r
TEL;X-Custom Field Name \r
 For Phone:1234567896\r
TEL;WORK:1234567892\r
TEL;HOME:1234567893\r
TEL;CELL:12345\r
 67891\r
TEL;FAX:1234567894\r
TEL;PAGER:1234567895\r
EMAIL;X-Custom Field \r
 Name For Email:test6@test.com\r
EMAIL;WORK:test2@test.com\r
EMAIL;HOME:test3@test.com\r
EMAIL;CELL:test1@test.com\r
EMAIL;FAX:test4\r
 @test.com\r
EMAIL;PAGER:test5@test.com\r
ORG:Organization Name;Organization\r
  Division;\r
TITLE:Organization Title\r
URL:www.website.com\r
NOTE:Notes\\nAnd\\nmore\\nlines\r
UNKNOWN \r
 FIELD LINE 1\r
UNKNOWN FIELD LINE 2\r
UNKNOWN FIELD LINE 3\r
UNKNOWN FIELD LINE 4\r
END:VCARD\r
\r
''';

//Alternative input string to "complex contact" (same imported data, but different input string)
//This one uses the "type" parameter for VCF typed fields
const String CONTACT_COMPLEX_ALTERNATE_INPUT_2 = '''BEGIN:VCARD\r
VERSION:2.1\r
PHOTO;ENCODING=BASE64;JPEG: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\r
FN:Full Name\r
N:Last name;First name;;;\r
NICKNAME:Nickname\r
ADR;X-Custom Address Field Name:;;Custom Street Address String;Custom Locality String;Custom Region String;Custom Postal Code String;Custom Country String\r
ADR;WORK:;;Work Street Address String;Work Locality String;Work Region String;Work Postal Code String;Work Country String\r
ADR;HOME:;;Home Street Address String;Home Locality String;Home Region String;Home Postal Code String;Home Country String\r
TEL;X-Custom Field Name For Phone:1234567896\r
TEL;WORK:1234567892\r
TEL;HOME:1234567893\r
TEL;CELL:1234567891\r
TEL;FAX:1234567894\r
TEL;PAGER:1234567895\r
EMAIL;X-Custom Field Name For Email:test6@test.com\r
EMAIL;WORK:test2@test.com\r
EMAIL;HOME:test3@test.com\r
EMAIL;CELL:test1@test.com\r
EMAIL;FAX:test4@test.com\r
EMAIL;PAGER:test5@test.com\r
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

//Alternative input string to "complex contact" (same imported data, but different input string)
//This one has random extra arguments to fields that should be ignored by the importer
const String CONTACT_COMPLEX_ALTERNATE_INPUT_3 = '''BEGIN:VCARD\r
VERSION:2.1\r
PHOTO;ENCODING=BASE64;JPEG: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\r
FN:Full Name\r
N:Last name;First name;;;\r
NICKNAME:Nickname\r
ADR;X-Custom Address Field Name:;;Custom Street Address String;Custom Locality String;Custom Region String;Custom Postal Code String;Custom Country String\r
ADR;WORK:;;Work Street Address String;Work Locality String;Work Region String;Work Postal Code String;Work Country String\r
ADR;HOME:;;Home Street Address String;Home Locality String;Home Region String;Home Postal Code String;Home Country String\r
TEL;X-Custom Field Name For Phone:1234567896\r
TEL;WORK:1234567892\r
TEL;HOME:1234567893\r
TEL;CELL:1234567891\r
TEL;FAX:1234567894\r
TEL;PAGER:1234567895\r
EMAIL;X-Custom Field Name For Email:test6@test.com\r
EMAIL;WORK:test2@test.com\r
EMAIL;HOME:test3@test.com\r
EMAIL;CELL:test1@test.com\r
EMAIL;FAX:test4@test.com\r
EMAIL;PAGER:test5@test.com\r
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

//Alternative input string to "complex contact 2" (same imported data, but different input string)
//This one has special characters that are properly excaped
const String CONTACT_COMPLEX_2_EXPECTED_OUTPUT = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Full Name $specialCharsEscaped\r
N:Last name $specialCharsEscaped;First name $specialCharsEscaped;;;\r
NICKNAME:Nickname $specialCharsEscaped\r
ADR;X-Custom Address Field Name $specialCharsEscaped:;;Custom Street Address String $specialCharsEscaped;Custom Locality String $specialCharsEscaped;Custom Region String $specialCharsEscaped;Custom Postal Code String $specialCharsEscaped;Custom Country String $specialCharsEscaped\r
ADR;WORK:;;Work Street Address String $specialCharsEscaped;Work Locality String $specialCharsEscaped;Work Region String $specialCharsEscaped;Work Postal Code String $specialCharsEscaped;Work Country String $specialCharsEscaped\r
ADR;HOME:;;Home Street Address String $specialCharsEscaped;Home Locality String $specialCharsEscaped;Home Region String $specialCharsEscaped;Home Postal Code String $specialCharsEscaped;Home Country String $specialCharsEscaped\r
TEL;X-Custom Field Name For Phone $specialCharsEscaped:1234567896 $specialCharsEscaped\r
TEL;WORK:1234567892 $specialCharsEscaped\r
TEL;HOME:1234567893 $specialCharsEscaped\r
TEL;CELL:1234567891 $specialCharsEscaped\r
TEL;FAX:1234567894 $specialCharsEscaped\r
TEL;PAGER:1234567895 $specialCharsEscaped\r
EMAIL;X-Custom Field Name For Email $specialCharsEscaped:test6@test.com $specialCharsEscaped\r
EMAIL;WORK:test2@test.com $specialCharsEscaped\r
EMAIL;HOME:test3@test.com $specialCharsEscaped\r
EMAIL;CELL:test1@test.com $specialCharsEscaped\r
EMAIL;FAX:test4@test.com $specialCharsEscaped\r
EMAIL;PAGER:test5@test.com $specialCharsEscaped\r
ORG:Organization Name $specialCharsEscaped;Organization Division $specialCharsEscaped;\r
TITLE:Organization Title $specialCharsEscaped\r
URL:www.website.com $specialCharsEscaped\r
NOTE:Notes\\nAnd\\nmore\\nlines $specialCharsEscaped\r
UNKNOWN FIELD LINE 1  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 2  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 3  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 4  ; & \\ : * & \' " . \t ~ @ ç\r
END:VCARD\r
\r
''';

//Alternative input string to "complex contact 2" (same imported data, but different input string)
//This one has special characters that are not properly escaped but do not conflict with field separation thus still imported
const String CONTACT_COMPLEX_2_ALTERNATE_INPUT_1 = '''BEGIN:VCARD\r
VERSION:2.1\r
FN:Full Name $specialCharsWorstlyEscaped\r
N:Last name $specialCharsBadlyEscaped;First name $specialCharsBadlyEscaped;;;\r
NICKNAME:Nickname $specialCharsWorstlyEscaped\r
ADR;X-Custom Address Field Name $specialCharsBadlyEscaped:;;Custom Street Address String $specialCharsBadlyEscaped;Custom Locality String $specialCharsBadlyEscaped;Custom Region String $specialCharsBadlyEscaped;Custom Postal Code String $specialCharsBadlyEscaped;Custom Country String $specialCharsBadlyEscaped\r
ADR;WORK:;;Work Street Address String $specialCharsBadlyEscaped;Work Locality String $specialCharsBadlyEscaped;Work Region String $specialCharsBadlyEscaped;Work Postal Code String $specialCharsBadlyEscaped;Work Country String $specialCharsBadlyEscaped\r
ADR;HOME:;;Home Street Address String $specialCharsBadlyEscaped;Home Locality String $specialCharsBadlyEscaped;Home Region String $specialCharsBadlyEscaped;Home Postal Code String $specialCharsBadlyEscaped;Home Country String $specialCharsBadlyEscaped\r
TEL;X-Custom Field Name For Phone $specialCharsBadlyEscaped:1234567896 $specialCharsWorstlyEscaped\r
TEL;WORK:1234567892 $specialCharsWorstlyEscaped\r
TEL;HOME:1234567893 $specialCharsWorstlyEscaped\r
TEL;CELL:1234567891 $specialCharsWorstlyEscaped\r
TEL;FAX:1234567894 $specialCharsWorstlyEscaped\r
TEL;PAGER:1234567895 $specialCharsWorstlyEscaped\r
EMAIL;X-Custom Field Name For Email $specialCharsBadlyEscaped:test6@test.com $specialCharsWorstlyEscaped\r
EMAIL;WORK:test2@test.com $specialCharsWorstlyEscaped\r
EMAIL;HOME:test3@test.com $specialCharsWorstlyEscaped\r
EMAIL;CELL:test1@test.com $specialCharsWorstlyEscaped\r
EMAIL;FAX:test4@test.com $specialCharsWorstlyEscaped\r
EMAIL;PAGER:test5@test.com $specialCharsWorstlyEscaped\r
ORG:Organization Name $specialCharsBadlyEscaped;Organization Division $specialCharsBadlyEscaped;\r
TITLE:Organization Title $specialCharsWorstlyEscaped\r
URL:www.website.com $specialCharsWorstlyEscaped\r
NOTE:Notes\\nAnd\\nmore\\nlines $specialCharsWorstlyEscaped\r
UNKNOWN FIELD LINE 1  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 2  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 3  ; & \\ : * & \' " . \t ~ @ ç\r
UNKNOWN FIELD LINE 4  ; & \\ : * & \' " . \t ~ @ ç\r
END:VCARD\r
\r
''';

const String CONTACTS_MULTIPLE_EXPECTED_OUTPUT = CONTACT_SIMPLEST_EXPECTED_OUTPUT +
    CONTACT_SIMPLE_EXPECTED_OUTPUT +
    CONTACT_COMPLEX_EXPECTED_OUTPUT +
    CONTACT_COMPLEX_2_EXPECTED_OUTPUT;

const Map<String, String> MOCK_FILES_BASE64_CONTENT = {
  '': null,
  'test/file/path/1.jpg':
      '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',
};
