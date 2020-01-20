import 'dart:convert';

import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class Contact {
  final int id;
  final String image;
  final String firstName;
  final String lastName;
  final String nickName;
  final String fullName;
  final List<StringLabeledField> phoneInfos;
  final List<StringLabeledField> emailInfos;
  final List<AddressLabeledField> addressInfos;
  final String organizationName;
  final String organizationDivision;
  final String organizationTitle;
  final String website;
  final String notes;
  final List<String> unknownVCFFieldLines;

  Contact(
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.nickName,
    this.fullName,
    this.phoneInfos,
    this.emailInfos,
    this.addressInfos,
    this.organizationName,
    this.organizationDivision,
    this.organizationTitle,
    this.website,
    this.notes,
    this.unknownVCFFieldLines,
  );

  NormalizedString _nFirstName;
  NormalizedString get nFirstName => _getNFirstName();
  NormalizedString _getNFirstName() {
    if (_nFirstName == null) {
      _nFirstName = NormalizedString(firstName);
    }
    return _nFirstName;
  }

  NormalizedString _nLastName;
  NormalizedString get nLastName => _getNLastName();
  NormalizedString _getNLastName() {
    if (_nLastName == null) {
      _nLastName = NormalizedString(lastName);
    }
    return _nLastName;
  }

  NormalizedString _nNickName;
  NormalizedString get nNickName => _getNNickName();
  NormalizedString _getNNickName() {
    if (_nNickName == null) {
      _nNickName = NormalizedString(nickName);
    }
    return _nNickName;
  }

  NormalizedString _nFullName;
  NormalizedString get nFullName => _getNFullName();
  NormalizedString _getNFullName() {
    if (_nFullName == null) {
      _nFullName = NormalizedString(fullName);
    }
    return _nFullName;
  }

  NormalizedString _nOrganizationName;
  NormalizedString get nOrganizationName => _getNOrganizationName();
  NormalizedString _getNOrganizationName() {
    if (_nOrganizationName == null) {
      _nOrganizationName = NormalizedString(organizationName);
    }
    return _nOrganizationName;
  }

  NormalizedString _nOrganizationDivision;
  NormalizedString get nOrganizationDivision => _getNOrganizationDivision();
  NormalizedString _getNOrganizationDivision() {
    if (_nOrganizationDivision == null) {
      _nOrganizationDivision = NormalizedString(organizationDivision);
    }
    return _nOrganizationDivision;
  }

  NormalizedString _nOrganizationTitle;
  NormalizedString get nOrganizationTitle => _getNOrganizationTitle();
  NormalizedString _getNOrganizationTitle() {
    if (_nOrganizationTitle == null) {
      _nOrganizationTitle = NormalizedString(organizationTitle);
    }
    return _nOrganizationTitle;
  }

  NormalizedString _nWebsite;
  NormalizedString get nWebsite => _getNWebsite();
  NormalizedString _getNWebsite() {
    if (_nWebsite == null) {
      _nWebsite = NormalizedString(website);
    }
    return _nWebsite;
  }

  NormalizedString _nNotes;
  NormalizedString get nNotes => _getNNotes();
  NormalizedString _getNNotes() {
    if (_nNotes == null) {
      _nNotes = NormalizedString(notes);
    }
    return _nNotes;
  }
}

class ContactBuilder {
  static const String JSON_FIELD_IMAGE = 'image';
  static const String JSON_FIELD_FIRST_NAME = 'first_name';
  static const String JSON_FIELD_LAST_NAME = 'last_name';
  static const String JSON_FIELD_NICK_NAME = 'nick_name';
  static const String JSON_FIELD_FULL_NAME = 'full_name';
  static const String JSON_FIELD_PHONE_INFOS = 'phone_infos';
  static const String JSON_FIELD_EMAIL_INFOS = 'email_infos';
  static const String JSON_FIELD_ADDRESS_INFOS = 'address_infos';
  static const String JSON_FIELD_ORGANIZATION_NAME = 'organization_name';
  static const String JSON_FIELD_ORGANIZATION_DIVISION = 'organization_division';
  static const String JSON_FIELD_ORGANIZATION_TITLE = 'organization_title';
  static const String JSON_FIELD_WEBSITE = 'website';
  static const String JSON_FIELD_NOTES = 'notes';
  static const String JSON_FIELD_UNKNOWN_VCF_FIELDS = 'unknown_vcf_fields';

  static String toJsonString(final ContactBuilder contactBuilder) {
    return jsonEncode({
      JSON_FIELD_IMAGE: contactBuilder._image,
      JSON_FIELD_FIRST_NAME: contactBuilder._firstName,
      JSON_FIELD_LAST_NAME: contactBuilder._lastName,
      JSON_FIELD_NICK_NAME: contactBuilder._nickName,
      JSON_FIELD_FULL_NAME: contactBuilder._fullName,
      JSON_FIELD_PHONE_INFOS: LabeledField.fieldsToMapList(contactBuilder._phoneInfos),
      JSON_FIELD_EMAIL_INFOS: LabeledField.fieldsToMapList(contactBuilder._emailInfos),
      JSON_FIELD_ADDRESS_INFOS: LabeledField.fieldsToMapList(contactBuilder._addressInfos),
      JSON_FIELD_ORGANIZATION_NAME: contactBuilder._organizationName,
      JSON_FIELD_ORGANIZATION_DIVISION: contactBuilder._organizationDivision,
      JSON_FIELD_ORGANIZATION_TITLE: contactBuilder._organizationTitle,
      JSON_FIELD_WEBSITE: contactBuilder._website,
      JSON_FIELD_NOTES: contactBuilder._notes,
      JSON_FIELD_UNKNOWN_VCF_FIELDS: contactBuilder._unknownVCFFieldLines
    });
  }

  static Contact buildFromJson(final int id, final String json) {
    final Map<String, dynamic> decodedJson = jsonDecode(json);
    final ContactBuilder contactBuilder = ContactBuilder();
    contactBuilder.setImage(decodedJson[JSON_FIELD_IMAGE]);
    contactBuilder.setFirstName(decodedJson[JSON_FIELD_FIRST_NAME]);
    contactBuilder.setLastName(decodedJson[JSON_FIELD_LAST_NAME]);
    contactBuilder.setNickName(decodedJson[JSON_FIELD_NICK_NAME]);
    contactBuilder.setFullName(decodedJson[JSON_FIELD_FULL_NAME]);
    contactBuilder.setPhoneInfos(LabeledField.fromMapList(
      List<StringLabeledField>(),
      decodedJson[JSON_FIELD_PHONE_INFOS],
      StringLabeledField.createFieldFunc,
    ));
    contactBuilder.setEmailInfos(LabeledField.fromMapList(
      List<StringLabeledField>(),
      decodedJson[JSON_FIELD_EMAIL_INFOS],
      StringLabeledField.createFieldFunc,
    ));
    contactBuilder.setAddressInfos(LabeledField.fromMapList(
      List<AddressLabeledField>(),
      decodedJson[JSON_FIELD_ADDRESS_INFOS],
      AddressLabeledField.createFieldFunc,
    ));
    contactBuilder.setOrganizationName(decodedJson[JSON_FIELD_ORGANIZATION_NAME]);
    contactBuilder.setOrganizationDivision(decodedJson[JSON_FIELD_ORGANIZATION_DIVISION]);
    contactBuilder.setOrganizationTitle(decodedJson[JSON_FIELD_ORGANIZATION_TITLE]);
    contactBuilder.setWebsite(decodedJson[JSON_FIELD_WEBSITE]);
    contactBuilder.setNotes(decodedJson[JSON_FIELD_NOTES]);
    final List<dynamic> unknownVCFFieldLines = decodedJson[JSON_FIELD_UNKNOWN_VCF_FIELDS];
    for (final dynamic line in unknownVCFFieldLines) {
      if (line is String) {
        contactBuilder.addUnknownVCFFieldLine(line);
      }
    }
    return contactBuilder.build(id);
  }

  String _image;
  String _fullName;
  String _firstName;
  String _lastName;
  String _nickName;
  List<StringLabeledField> _phoneInfos;
  List<StringLabeledField> _emailInfos;
  List<LabeledField<AddressInfo>> _addressInfos;
  String _organizationName;
  String _organizationDivision;
  String _organizationTitle;
  String _website;
  String _notes;
  final List<String> _unknownVCFFieldLines = [];

  static List<StringLabeledField> getSanitizedStringLabeledField(final List<StringLabeledField> list) {
    if (list == null) {
      return [];
    }
    final List<StringLabeledField> res = [];
    for (final StringLabeledField f in list) {
      if (f.fieldValue.trim().isNotEmpty) {
        res.add(f);
      }
    }
    res.sort((a, b) {
      return a.labelType.index - b.labelType.index;
    });
    return res;
  }

  static List<AddressLabeledField> getSanitizedAddressLabeledField(final List<AddressLabeledField> list) {
    if (list == null) {
      return [];
    }
    final List<AddressLabeledField> res = [];
    for (final AddressLabeledField f in list) {
      if (f.fieldValue == null) {
        continue;
      }
      if (f.fieldValue.streetAddress.isEmpty &&
          f.fieldValue.locality.isEmpty &&
          f.fieldValue.region.isEmpty &&
          f.fieldValue.postalCode.isEmpty &&
          f.fieldValue.country.isEmpty) {
        continue;
      }
      res.add(f);
    }
    res.sort((a, b) {
      return a.labelType.index - b.labelType.index;
    });
    return res;
  }

  static String getNonNullString(final String str) {
    if (str == null) {
      return '';
    }
    return str;
  }

  Contact build(final int id) {
    if (id == null) {
      return null;
    }
    return Contact(
      id,
      _image,
      getNonNullString(_firstName),
      getNonNullString(_lastName),
      getNonNullString(_nickName),
      getNonNullString(_fullName),
      getSanitizedStringLabeledField(_phoneInfos),
      getSanitizedStringLabeledField(_emailInfos),
      getSanitizedAddressLabeledField(_addressInfos),
      getNonNullString(_organizationName),
      getNonNullString(_organizationDivision),
      getNonNullString(_organizationTitle),
      getNonNullString(_website),
      getNonNullString(_notes),
      _unknownVCFFieldLines,
    );
  }

  ContactBuilder setImage(final String image) {
    _image = image;
    return this;
  }

  ContactBuilder setFirstName(final String firstName) {
    _firstName = firstName;
    return this;
  }

  ContactBuilder setLastName(final String lastName) {
    _lastName = lastName;
    return this;
  }

  ContactBuilder setNickName(final String nickName) {
    _nickName = nickName;
    return this;
  }

  ContactBuilder setFullName(final String fullName) {
    _fullName = fullName;
    return this;
  }

  ContactBuilder setPhoneInfos(final List<StringLabeledField> phoneInfos) {
    _phoneInfos = phoneInfos;
    return this;
  }

  ContactBuilder setEmailInfos(final List<StringLabeledField> emailInfos) {
    _emailInfos = emailInfos;
    return this;
  }

  ContactBuilder setAddressInfos(final List<AddressLabeledField> addressInfos) {
    _addressInfos = addressInfos;
    return this;
  }

  ContactBuilder setOrganizationName(final String organizationName) {
    _organizationName = organizationName;
    return this;
  }

  ContactBuilder setOrganizationDivision(final String organizationDivision) {
    _organizationDivision = organizationDivision;
    return this;
  }

  ContactBuilder setOrganizationTitle(final String organizationTitle) {
    _organizationTitle = organizationTitle;
    return this;
  }

  ContactBuilder setWebsite(final String website) {
    _website = website;
    return this;
  }

  ContactBuilder setNotes(final String notes) {
    _notes = notes;
    return this;
  }

  ContactBuilder addUnknownVCFFieldLine(String fieldLine) {
    _unknownVCFFieldLines.add(fieldLine);
    return this;
  }
}
