class VCFConstants {
  //The separation character to mark a line return between fields
  static const VCF_LINE_RETURN_FIELD_SEPARATION = '\r\n';
  static const Map<String, String> VCF_ESCAPED_CHARS_MAP = {
    '\\': '\\\\',
    ',': '\\,',
    ':': '\\:',
    ';': '\\;',
    '\n': '\\n',
  };
  static const Map<String, String> VCF_UNESCAPED_CHARS_MAP = {
    '\\\\': '\\',
    '\\,': ',',
    '\\:': ':',
    '\\;': ';',
    '\\n': '\n',
  };
  static const String VCF_SEPARATOR_COMMA = ',';
  static const String VCF_SEPARATOR_COLON = ':';
  static const String VCF_SEPARATOR_SEMICOLON = ';';
  static const String VCF_SEPARATOR_EQUAL = '=';
  static const VCF_VERSION_LINE = 'VERSION:2.1';

  static const FIELD_BEGIN_VCARD = 'BEGIN:VCARD';
  static const FIELD_END_VCARD = 'END:VCARD';
  static const FIELD_VERSION = 'VERSION';
  static const FIELD_UID = 'UID';
  static const FIELD_PHOTO = 'PHOTO';
  static const FIELD_FULL_NAME = 'FN';
  static const FIELD_NAME = 'N';
  static const FIELD_NICKNAME = 'NICKNAME';
  static const FIELD_ADRESS = 'ADR';
  static const FIELD_PHONE = 'TEL';
  static const FIELD_EMAIL = 'EMAIL';
  static const FIELD_ORG = 'ORG';
  static const FIELD_TITLE = 'TITLE';
  static const FIELD_URL = 'URL';
  static const FIELD_NOTE = 'NOTE';

  static const FIELD_PARAM_TYPE = 'type';
}
