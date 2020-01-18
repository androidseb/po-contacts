import 'package:po_contacts_flutter/controller/vcard/vcf_reader.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_writer.dart';
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

  static void writeToVCF(final List<Contact> contacts, final VCFWriter vcfWriter) {
    if (contacts == null) {
      return;
    }
    for (final Contact c in contacts) {
      vcfWriter.writeContact(c);
    }
  }
}
