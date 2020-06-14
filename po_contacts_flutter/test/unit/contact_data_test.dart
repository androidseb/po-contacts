import 'package:flutter_test/flutter_test.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

void main() {
  test('Contact data can convert an external ID to a UID', () async {
    expect(ContactData.externalIdToUid(null), null);
    expect(ContactData.externalIdToUid(0), 'f81d4fae-7dec-11d0-a765-000000000000');
    expect(ContactData.externalIdToUid(1), 'f81d4fae-7dec-11d0-a765-000000000001');
    expect(ContactData.externalIdToUid(9), 'f81d4fae-7dec-11d0-a765-000000000009');
    expect(ContactData.externalIdToUid(10), 'f81d4fae-7dec-11d0-a765-000000000010');
    expect(ContactData.externalIdToUid(99), 'f81d4fae-7dec-11d0-a765-000000000099');
    expect(ContactData.externalIdToUid(12345678901), 'f81d4fae-7dec-11d0-a765-012345678901');
    expect(ContactData.externalIdToUid(123456789012), 'f81d4fae-7dec-11d0-a765-123456789012');
    expect(ContactData.externalIdToUid(1234567890123), 'f81d4fae-7dec-11d0-a765-123456789012');
    expect(ContactData.externalIdToUid(123456789012345), 'f81d4fae-7dec-11d0-a765-123456789012');
  });

  test('Contact data can convert a UID to an external ID', () async {
    expect(ContactData.uidToExternalId(null), null);
    expect(ContactData.uidToExternalId('qwerty'), null);
    expect(ContactData.uidToExternalId('99999999-7dec-11d0-a765-000000000000'), null);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-000000000000'), 0);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-000000000001'), 1);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-000000000009'), 9);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-000000000010'), 10);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-000000000099'), 99);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-012345678901'), 12345678901);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-123456789012'), 123456789012);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-1234567890123'), 1234567890123);
    expect(ContactData.uidToExternalId('f81d4fae-7dec-11d0-a765-123456789012345'), 123456789012345);
  });
}
