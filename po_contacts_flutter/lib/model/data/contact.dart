import 'package:po_contacts_flutter/model/data/email_info.dart';
import 'package:po_contacts_flutter/model/data/phone_info.dart';

class Contact {
  final String firstName;
  final String lastName;
  final List<PhoneInfo> phoneInfos;
  final List<EmailInfo> emailInfos;

  Contact(this.firstName, this.lastName, this.phoneInfos, this.emailInfos);
}

class ContactBuilder {
  String _firstName;
  String _lastName;
  List<PhoneInfo> _phoneInfos = [];
  List<EmailInfo> _emailInfos = [];

  Contact build() {
    if (_firstName == null && _lastName == null) {
      return null;
    }
    String firstName = '';
    String lastName = '';
    if (_firstName != null) {
      firstName = _firstName;
    }
    if (_lastName != null) {
      lastName = _lastName;
    }
    return Contact(firstName, lastName, _phoneInfos, _emailInfos);
  }

  ContactBuilder setFirstName(final String firstName) {
    _firstName = firstName;
    return this;
  }

  ContactBuilder setLastName(final String lastName) {
    _lastName = lastName;
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
}
