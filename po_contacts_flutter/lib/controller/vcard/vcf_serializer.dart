import 'package:po_contacts_flutter/controller/vcard/reader/vcf_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/vcf_writer.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';

//Serializer for vcard based on specs here:
//https://tools.ietf.org/html/rfc6350
class VCFSerializer {
  static Future<List<ContactBuilder>> readFromVCF(final VCFReader vcfReader) async {
    final List<ContactBuilder> res = [];
    ContactBuilder lastReadContact;
    do {
      lastReadContact = await vcfReader.readContact();
      if (lastReadContact != null) {
        res.add(lastReadContact);
      }
    } while (lastReadContact != null);
    return res;
  }

  static Future<void> writeToVCF(
    final List<Contact> contacts,
    final VCFWriter vcfWriter,
    final Function(int progress) progressCallback,
  ) async {
    if (contacts == null) {
      return;
    }
    for (int i = 0; i < contacts.length; i++) {
      final Contact c = contacts[i];
      await vcfWriter.writeContact(c);
      await progressCallback((100 * (i + 1) / contacts.length).floor());
    }
  }
}
