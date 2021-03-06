import 'dart:convert';

import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

abstract class ContactData {
  static const String JSON_FIELD_UID = 'uid';
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

  String get uid;
  String get image;
  String get firstName;
  String get lastName;
  String get nickName;
  String get fullName;
  List<StringLabeledField> get phoneInfos;
  List<StringLabeledField> get emailInfos;
  List<AddressLabeledField> get addressInfos;
  String get organizationName;
  String get organizationDivision;
  String get organizationTitle;
  String get website;
  String get notes;
  List<String> get unknownVCFFieldLines;

  static String toJsonString(final ContactData contactData) {
    return jsonEncode({
      JSON_FIELD_UID: contactData.uid,
      JSON_FIELD_IMAGE: contactData.image,
      JSON_FIELD_FIRST_NAME: contactData.firstName,
      JSON_FIELD_LAST_NAME: contactData.lastName,
      JSON_FIELD_NICK_NAME: contactData.nickName,
      JSON_FIELD_FULL_NAME: contactData.fullName,
      JSON_FIELD_PHONE_INFOS: LabeledField.fieldsToMapList(contactData.phoneInfos),
      JSON_FIELD_EMAIL_INFOS: LabeledField.fieldsToMapList(contactData.emailInfos),
      JSON_FIELD_ADDRESS_INFOS: LabeledField.fieldsToMapList(contactData.addressInfos),
      JSON_FIELD_ORGANIZATION_NAME: contactData.organizationName,
      JSON_FIELD_ORGANIZATION_DIVISION: contactData.organizationDivision,
      JSON_FIELD_ORGANIZATION_TITLE: contactData.organizationTitle,
      JSON_FIELD_WEBSITE: contactData.website,
      JSON_FIELD_NOTES: contactData.notes,
      JSON_FIELD_UNKNOWN_VCF_FIELDS: contactData.unknownVCFFieldLines
    });
  }
}

class Contact extends ContactData {
  final int id;
  final String uid;
  final String _image;
  final String _firstName;
  final String _lastName;
  final String _nickName;
  final String _fullName;
  final List<StringLabeledField> _phoneInfos;
  final List<StringLabeledField> _emailInfos;
  final List<AddressLabeledField> _addressInfos;
  final String _organizationName;
  final String _organizationDivision;
  final String _organizationTitle;
  final String _website;
  final String _notes;
  final List<String> _unknownVCFFieldLines;

  Contact(
    this.id,
    this.uid,
    this._image,
    this._firstName,
    this._lastName,
    this._nickName,
    this._fullName,
    this._phoneInfos,
    this._emailInfos,
    this._addressInfos,
    this._organizationName,
    this._organizationDivision,
    this._organizationTitle,
    this._website,
    this._notes,
    this._unknownVCFFieldLines,
  ) : super();

  @override
  String get image => _image;
  @override
  String get firstName => _firstName;
  @override
  String get lastName => _lastName;
  @override
  String get nickName => _nickName;
  @override
  String get fullName => _fullName;
  @override
  List<StringLabeledField> get phoneInfos => _phoneInfos;
  @override
  List<StringLabeledField> get emailInfos => _emailInfos;
  @override
  List<AddressLabeledField> get addressInfos => _addressInfos;
  @override
  String get organizationName => _organizationName;
  @override
  String get organizationDivision => _organizationDivision;
  @override
  String get organizationTitle => _organizationTitle;
  @override
  String get website => _website;
  @override
  String get notes => _notes;
  @override
  List<String> get unknownVCFFieldLines => _unknownVCFFieldLines;

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

  static bool equalExceptId(final Contact item1, final Contact item2) {
    if (item1 == item2) {
      return true;
    }
    if (item1 == null || item2 == null) {
      return false;
    }
    if (item1.firstName != item2.firstName) return false;
    if (item1.lastName != item2.lastName) return false;
    if (item1.nickName != item2.nickName) return false;
    if (item1.fullName != item2.fullName) return false;
    if (item1.organizationName != item2.organizationName) return false;
    if (item1.organizationDivision != item2.organizationDivision) return false;
    if (item1.organizationTitle != item2.organizationTitle) return false;
    if (item1.website != item2.website) return false;
    if (item1.notes != item2.notes) return false;
    if (!Utils.areListsEqual(
      item1.phoneInfos,
      item2.phoneInfos,
      equalsFunction: StringLabeledField.areEqual,
    )) {
      return false;
    }
    if (!Utils.areListsEqual(
      item1.emailInfos,
      item2.emailInfos,
      equalsFunction: StringLabeledField.areEqual,
    )) {
      return false;
    }
    if (!Utils.areListsEqual(
      item1.addressInfos,
      item2.addressInfos,
      equalsFunction: AddressLabeledField.areEqual,
    )) {
      return false;
    }
    if (!Utils.areListsEqual(item1.unknownVCFFieldLines, item2.unknownVCFFieldLines)) return false;
    return true;
  }
}

class ContactBuilder extends ContactData {
  static Contact buildFromJson(final int id, final String json) {
    final Map<String, dynamic> decodedJson = jsonDecode(json);
    final ContactBuilder contactBuilder = ContactBuilder();
    contactBuilder.setUID(decodedJson[ContactData.JSON_FIELD_UID]);
    contactBuilder.setImage(decodedJson[ContactData.JSON_FIELD_IMAGE]);
    contactBuilder.setFirstName(decodedJson[ContactData.JSON_FIELD_FIRST_NAME]);
    contactBuilder.setLastName(decodedJson[ContactData.JSON_FIELD_LAST_NAME]);
    contactBuilder.setNickName(decodedJson[ContactData.JSON_FIELD_NICK_NAME]);
    contactBuilder.setFullName(decodedJson[ContactData.JSON_FIELD_FULL_NAME]);
    contactBuilder.setPhoneInfos(LabeledField.fromMapList(
      List<StringLabeledField>(),
      decodedJson[ContactData.JSON_FIELD_PHONE_INFOS],
      StringLabeledField.createFieldFunc,
    ));
    contactBuilder.setEmailInfos(LabeledField.fromMapList(
      List<StringLabeledField>(),
      decodedJson[ContactData.JSON_FIELD_EMAIL_INFOS],
      StringLabeledField.createFieldFunc,
    ));
    contactBuilder.setAddressInfos(LabeledField.fromMapList(
      List<AddressLabeledField>(),
      decodedJson[ContactData.JSON_FIELD_ADDRESS_INFOS],
      AddressLabeledField.createFieldFunc,
    ));
    contactBuilder.setOrganizationName(decodedJson[ContactData.JSON_FIELD_ORGANIZATION_NAME]);
    contactBuilder.setOrganizationDivision(decodedJson[ContactData.JSON_FIELD_ORGANIZATION_DIVISION]);
    contactBuilder.setOrganizationTitle(decodedJson[ContactData.JSON_FIELD_ORGANIZATION_TITLE]);
    contactBuilder.setWebsite(decodedJson[ContactData.JSON_FIELD_WEBSITE]);
    contactBuilder.setNotes(decodedJson[ContactData.JSON_FIELD_NOTES]);
    final List<dynamic> unknownVCFFieldLines = decodedJson[ContactData.JSON_FIELD_UNKNOWN_VCF_FIELDS];
    for (final dynamic line in unknownVCFFieldLines) {
      if (line is String) {
        contactBuilder.addUnknownVCFFieldLine(line);
      }
    }
    return ContactBuilder.build(id, contactBuilder);
  }

  String _uid = Utils.generateUUID();
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

  String get uid => _uid;
  @override
  String get image => _image;
  @override
  String get firstName => _firstName;
  @override
  String get lastName => _lastName;
  @override
  String get nickName => _nickName;
  @override
  String get fullName => _fullName;
  @override
  List<StringLabeledField> get phoneInfos => _phoneInfos;
  @override
  List<StringLabeledField> get emailInfos => _emailInfos;
  @override
  List<AddressLabeledField> get addressInfos => _addressInfos;
  @override
  String get organizationName => _organizationName;
  @override
  String get organizationDivision => _organizationDivision;
  @override
  String get organizationTitle => _organizationTitle;
  @override
  String get website => _website;
  @override
  String get notes => _notes;
  @override
  List<String> get unknownVCFFieldLines => _unknownVCFFieldLines;

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
      if (f.fieldValue.postOfficeBox.isEmpty &&
          f.fieldValue.extendedAddress.isEmpty &&
          f.fieldValue.streetAddress.isEmpty &&
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

  static Contact build(
    final int id,
    final ContactData contactData, {
    final String uuidOverride = null,
  }) {
    if (id == null) {
      return null;
    }
    String uuid;
    if (uuidOverride == null) {
      uuid = contactData.uid == null ? '$id' : contactData.uid;
    } else {
      uuid = uuidOverride;
    }
    return Contact(
      id,
      uuid,
      contactData.image,
      getNonNullString(contactData.firstName),
      getNonNullString(contactData.lastName),
      getNonNullString(contactData.nickName),
      getNonNullString(contactData.fullName),
      getSanitizedStringLabeledField(contactData.phoneInfos),
      getSanitizedStringLabeledField(contactData.emailInfos),
      getSanitizedAddressLabeledField(contactData.addressInfos),
      getNonNullString(contactData.organizationName),
      getNonNullString(contactData.organizationDivision),
      getNonNullString(contactData.organizationTitle),
      getNonNullString(contactData.website),
      getNonNullString(contactData.notes),
      contactData.unknownVCFFieldLines,
    );
  }

  ContactBuilder setUID(final String uid) {
    if (uid != null) {
      _uid = uid;
    }
    return this;
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
