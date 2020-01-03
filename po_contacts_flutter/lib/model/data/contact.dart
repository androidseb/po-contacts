import 'package:po_contacts_flutter/model/data/email_info.dart';
import 'package:po_contacts_flutter/model/data/phone_info.dart';

class Contact {
  final String name;
  final List<PhoneInfo> phoneInfos;
  final List<EmailInfo> emailInfos;
  final String address;
  final String organizationName;
  final String organizationTitle;
  final String notes;

  Contact(
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
  String _name;
  List<PhoneInfo> _phoneInfos;
  List<EmailInfo> _emailInfos;
  String _address;
  String _organizationName;
  String _organizationTitle;
  String _notes;

  Contact build() {
    if (_name == null) {
      return null;
    }
    String name = '';
    List<PhoneInfo> phoneInfos = [];
    List<EmailInfo> emailInfos = [];
    String address = '';
    String organizationName = '';
    String organizationTitle = '';
    String notes = '';
    if (_name != null) {
      name = _name;
    }
    if (_phoneInfos != null) {
      phoneInfos = _phoneInfos;
    }
    if (_emailInfos != null) {
      emailInfos = _emailInfos;
    }
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
      name,
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

  ContactBuilder setPhoneInfos(final List<PhoneInfo> phoneInfos) {
    _phoneInfos = phoneInfos;
    return this;
  }

  ContactBuilder setEmailInfos(final List<EmailInfo> emailInfos) {
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
