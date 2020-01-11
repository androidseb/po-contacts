import 'dart:convert';

import 'package:po_contacts_flutter/model/data/labeled_field.dart';

class Contact {
  final int id;
  final String name;
  final List<LabeledField> phoneInfos;
  final List<LabeledField> emailInfos;
  final String address;
  final String organizationName;
  final String organizationTitle;
  final String notes;

  Contact(
    this.id,
    this.name,
    this.phoneInfos,
    this.emailInfos,
    this.address,
    this.organizationName,
    this.organizationTitle,
    this.notes,
  );
}

class ContactBuilder {
  static const String JSON_FIELD_NAME = 'name';
  static const String JSON_FIELD_PHONE_INFOS = 'phone_infos';
  static const String JSON_FIELD_EMAIL_INFOS = 'email_infos';
  static const String JSON_FIELD_ADDRESS = 'address';
  static const String JSON_FIELD_ORGANIZATION_NAME = 'organization_name';
  static const String JSON_FIELD_ORGANIZATION_TITLE = 'organization_title';
  static const String JSON_FIELD_NOTES = 'notes';

  static String toJsonString(final ContactBuilder contactBuilder) {
    return jsonEncode({
      JSON_FIELD_NAME: contactBuilder._name,
      JSON_FIELD_PHONE_INFOS: LabeledField.fieldsToMapList(contactBuilder._phoneInfos),
      JSON_FIELD_EMAIL_INFOS: LabeledField.fieldsToMapList(contactBuilder._emailInfos),
      JSON_FIELD_ADDRESS: contactBuilder._address,
      JSON_FIELD_ORGANIZATION_NAME: contactBuilder._organizationName,
      JSON_FIELD_ORGANIZATION_TITLE: contactBuilder._organizationTitle,
      JSON_FIELD_NOTES: contactBuilder._notes,
    });
  }

  static Contact buildFromJson(final int id, final String json) {
    final Map<String, dynamic> decodedJson = jsonDecode(json);
    final ContactBuilder contactBuilder = ContactBuilder();
    contactBuilder.setName(decodedJson[JSON_FIELD_NAME]);
    contactBuilder.setPhoneInfos(LabeledField.fromMapList(decodedJson[JSON_FIELD_PHONE_INFOS]));
    contactBuilder.setEmailInfos(LabeledField.fromMapList(decodedJson[JSON_FIELD_EMAIL_INFOS]));
    contactBuilder.setAddress(decodedJson[JSON_FIELD_ADDRESS]);
    contactBuilder.setOrganizationName(decodedJson[JSON_FIELD_ORGANIZATION_NAME]);
    contactBuilder.setOrganizationTitle(decodedJson[JSON_FIELD_ORGANIZATION_TITLE]);
    contactBuilder.setNotes(decodedJson[JSON_FIELD_NOTES]);
    return contactBuilder.build(id);
  }

  String _name;
  List<LabeledField> _phoneInfos;
  List<LabeledField> _emailInfos;
  String _address;
  String _organizationName;
  String _organizationTitle;
  String _notes;

  static List<LabeledField> getSanitizedLabeledField(final List<LabeledField> list) {
    if (list == null) {
      return [];
    }
    final List<LabeledField> res = [];
    for (final LabeledField f in list) {
      if (f.textValue.trim().isNotEmpty) {
        res.add(f);
      }
    }
    res.sort((a, b) {
      return a.labelType.index - b.labelType.index;
    });
    return res;
  }

  Contact build(final int id) {
    if (id == null || _name == null) {
      return null;
    }
    final List<LabeledField> phoneInfos = getSanitizedLabeledField(_phoneInfos);
    List<LabeledField> emailInfos = getSanitizedLabeledField(_emailInfos);
    String address = '';
    String organizationName = '';
    String organizationTitle = '';
    String notes = '';
    if (_address != null) {
      address = _address;
    }
    if (_organizationName != null) {
      organizationName = _organizationName;
    }
    if (_organizationTitle != null) {
      organizationTitle = _organizationTitle;
    }
    if (_notes != null) {
      notes = _notes;
    }
    return Contact(
      id,
      _name,
      phoneInfos,
      emailInfos,
      address,
      organizationName,
      organizationTitle,
      notes,
    );
  }

  ContactBuilder setName(final String name) {
    _name = name;
    return this;
  }

  ContactBuilder setPhoneInfos(final List<LabeledField> phoneInfos) {
    _phoneInfos = phoneInfos;
    return this;
  }

  ContactBuilder setEmailInfos(final List<LabeledField> emailInfos) {
    _emailInfos = emailInfos;
    return this;
  }

  ContactBuilder setAddress(final String address) {
    _address = address;
    return this;
  }

  ContactBuilder setOrganizationName(final String organizationName) {
    _organizationName = organizationName;
    return this;
  }

  ContactBuilder setOrganizationTitle(final String organizationTitle) {
    _organizationTitle = organizationTitle;
    return this;
  }

  ContactBuilder setNotes(final String notes) {
    _notes = notes;
    return this;
  }
}
