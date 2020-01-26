import 'package:po_contacts_flutter/controller/vcard/writer/abs_file_reader.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

class DiskFileReader extends FileReader {
  Future<String> fileToBase64String(String filePath) {
    return Utils.fileContentToBase64String(filePath);
  }
}
