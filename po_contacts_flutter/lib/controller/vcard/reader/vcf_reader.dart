import 'package:po_contacts_flutter/controller/platform/common/file_entity.dart';
import 'package:po_contacts_flutter/controller/vcard/field/vcf_field.dart';
import 'package:po_contacts_flutter/controller/vcard/field/vcf_multi_value_field.dart';
import 'package:po_contacts_flutter/controller/vcard/field/vcf_single_value_field.dart';
import 'package:po_contacts_flutter/controller/vcard/reader/abs_file_inflater.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

abstract class VCFReader {
  final FileInflater fileInflater;

  VCFReader(this.fileInflater);

  Future<String> readLineImpl();

  String _pendingReadLine;

  Future<String> _readFieldLine() async {
    String readLine;
    if (_pendingReadLine == null) {
      readLine = await readLineImpl();
    } else {
      readLine = _pendingReadLine;
      _pendingReadLine = null;
    }
    if (readLine == null) {
      return null;
    }
    final StringBuffer res = StringBuffer();
    while (true) {
      if (readLine != null) {
        res.write(readLine);
        readLine = await readLineImpl();
      }
      if (readLine == null) {
        break;
      } else if (readLine.startsWith(' ')) {
        readLine = readLine.substring(1);
      } else {
        _pendingReadLine = readLine;
        break;
      }
    }
    return res.toString();
  }

  Future<List<String>> _readContactFieldLines() async {
    final List<String> res = [];
    String fieldLine;

    //Process all field lines until we find the BEGIN:VCARD field
    fieldLine = await _readFieldLine();
    while (fieldLine != null && !fieldLine.startsWith(VCFConstants.FIELD_BEGIN_VCARD)) {
      fieldLine = await _readFieldLine();
    }

    //If we couldn't get to the BEGIN:VCARD field, we stop here
    if (fieldLine == null) {
      return res;
    }

    //We add all lines we find until we hit reach a END:VCARD field or the end of the file
    fieldLine = await _readFieldLine();
    while (fieldLine != null && !fieldLine.startsWith(VCFConstants.FIELD_END_VCARD)) {
      res.add(fieldLine);
      fieldLine = await _readFieldLine();
    }

    return res;
  }

  static bool isLineForField(final String fieldLine, final String fieldName) {
    return fieldLine.startsWith('$fieldName:') || fieldLine.startsWith('$fieldName;');
  }

  static SingleValueField getSingleValueField(final String fieldLine, final String fieldName) {
    if (isLineForField(fieldLine, fieldName)) {
      return SingleValueField.create(fieldName, fieldLine);
    } else {
      return null;
    }
  }

  static MultiValueField getMultiValueField(final String fieldLine, final String fieldName) {
    if (isLineForField(fieldLine, fieldName)) {
      return MultiValueField.create(fieldName, fieldLine);
    } else {
      return null;
    }
  }

  static VCFFieldLabelParamValue getLabeledFieldLabelTypeForFieldParams(final Map<String, String> fieldParams) {
    LabeledFieldLabelType resultLabelType = LabeledFieldLabelType.work;
    String resultLabelText = '';
    for (final String key in fieldParams.keys) {
      final String value = fieldParams[key];
      if (Utils.stringEqualsIgnoreCase(key, VCFConstants.FIELD_PARAM_TYPE)) {
        resultLabelType = LabeledField.stringToLabeledFieldLabelType(
          value,
          LabeledFieldLabelType.custom,
        );
        if (resultLabelType == LabeledFieldLabelType.custom) {
          resultLabelText = value;
        }
        break;
      }
      if (value.isEmpty && key.startsWith('X-')) {
        resultLabelType = LabeledFieldLabelType.custom;
        resultLabelText = VCFField.unEscapeVCFString(key.substring(2));
        break;
      }
      final LabeledFieldLabelType foundClearType = LabeledField.stringToLabeledFieldLabelType(
        key,
        null,
      );
      if (foundClearType != null) {
        resultLabelType = foundClearType;
        break;
      }
    }
    return VCFFieldLabelParamValue(
      resultLabelType,
      resultLabelText,
    );
  }

  processContactFieldLine(
    final ContactBuilder contactBuilder,
    final List<StringLabeledField> phones,
    final List<StringLabeledField> emails,
    final List<AddressLabeledField> addresses,
    final String fieldLine,
  ) async {
    if (fieldLine == null) {
      return;
    }

    final SingleValueField versionField = getSingleValueField(fieldLine, VCFConstants.FIELD_VERSION);
    if (versionField != null) {
      return;
    }

    final SingleValueField photoField = getSingleValueField(fieldLine, VCFConstants.FIELD_PHOTO);
    if (photoField != null) {
      String fileExtension = '.jpg';
      if (photoField.fieldParams['PNG'] == '') {
        fileExtension = '.png';
      }
      final FileEntity imageFile = await fileInflater.createNewImageFile(fileExtension);
      final bool fileWriteSuccess = await imageFile.writeBase64String(photoField.fieldValue);
      if (fileWriteSuccess) {
        contactBuilder.setImage(imageFile.getAbsolutePath());
      } else {
        await imageFile.delete();
      }
      return;
    }

    final SingleValueField fnField = getSingleValueField(fieldLine, VCFConstants.FIELD_FULL_NAME);
    if (fnField != null) {
      contactBuilder.setFullName(fnField.fieldValue);
      return;
    }

    final MultiValueField nField = getMultiValueField(fieldLine, VCFConstants.FIELD_NAME);
    if (nField != null) {
      if (nField.fieldValues.isNotEmpty) {
        contactBuilder.setLastName(nField.fieldValues[0]);
        if (nField.fieldValues.length > 1) {
          contactBuilder.setFirstName(nField.fieldValues[1]);
        }
      }
      return;
    }

    final SingleValueField nnField = getSingleValueField(fieldLine, VCFConstants.FIELD_NICKNAME);
    if (nnField != null) {
      contactBuilder.setNickName(nnField.fieldValue);
      return;
    }

    final MultiValueField addrField = getMultiValueField(fieldLine, VCFConstants.FIELD_ADRESS);
    if (addrField != null && addrField.fieldValues.isNotEmpty) {
      final VCFFieldLabelParamValue typeFieldValue = getLabeledFieldLabelTypeForFieldParams(
        addrField.fieldParams,
      );
      String streetAddress = '';
      String locality = '';
      String region = '';
      String postalCode = '';
      String country = '';
      if (addrField.fieldValues.length > 2) {
        streetAddress = addrField.fieldValues[2];
      }
      if (addrField.fieldValues.length > 3) {
        locality = addrField.fieldValues[3];
      }
      if (addrField.fieldValues.length > 4) {
        region = addrField.fieldValues[4];
      }
      if (addrField.fieldValues.length > 5) {
        postalCode = addrField.fieldValues[5];
      }
      if (addrField.fieldValues.length > 6) {
        country = addrField.fieldValues[6];
      }
      addresses.add(AddressLabeledField(
          typeFieldValue.labelType,
          typeFieldValue.labelText,
          AddressInfo(
            streetAddress,
            locality,
            region,
            postalCode,
            country,
          )));
      return;
    }

    final SingleValueField phoneField = getSingleValueField(fieldLine, VCFConstants.FIELD_PHONE);
    if (phoneField != null) {
      final VCFFieldLabelParamValue typeFieldValue = getLabeledFieldLabelTypeForFieldParams(
        phoneField.fieldParams,
      );
      phones.add(StringLabeledField(
        typeFieldValue.labelType,
        typeFieldValue.labelText,
        phoneField.fieldValue,
      ));
      return;
    }

    final SingleValueField emailField = getSingleValueField(fieldLine, VCFConstants.FIELD_EMAIL);
    if (emailField != null) {
      final VCFFieldLabelParamValue typeFieldValue = getLabeledFieldLabelTypeForFieldParams(
        emailField.fieldParams,
      );
      emails.add(StringLabeledField(
        typeFieldValue.labelType,
        typeFieldValue.labelText,
        emailField.fieldValue,
      ));
      return;
    }

    final MultiValueField orgField = getMultiValueField(fieldLine, VCFConstants.FIELD_ORG);
    if (orgField != null && orgField.fieldValues.isNotEmpty) {
      contactBuilder.setOrganizationName(orgField.fieldValues[0]);
      if (orgField.fieldValues.length > 1) {
        contactBuilder.setOrganizationDivision(orgField.fieldValues[1]);
      }
      return;
    }

    final SingleValueField titleField = getSingleValueField(fieldLine, VCFConstants.FIELD_TITLE);
    if (titleField != null) {
      contactBuilder.setOrganizationTitle(titleField.fieldValue);
      return;
    }

    final SingleValueField urlField = getSingleValueField(fieldLine, VCFConstants.FIELD_URL);
    if (urlField != null) {
      contactBuilder.setWebsite(urlField.fieldValue);
      return;
    }

    final SingleValueField noteField = getSingleValueField(fieldLine, VCFConstants.FIELD_NOTE);
    if (noteField != null) {
      contactBuilder.setNotes(noteField.fieldValue);
      return;
    }

    if (fieldLine.trim().isEmpty) {
      return;
    }

    //If none of the above were recognized as a field, we save this as an unknown field line
    //This will ensure no imported contact fields are lost when we export
    contactBuilder.addUnknownVCFFieldLine(fieldLine);
  }

  Future<ContactBuilder> readContact() async {
    final ContactBuilder res = ContactBuilder();
    final List<String> contactFieldLines = await _readContactFieldLines();
    if (contactFieldLines.isEmpty) {
      return null;
    }
    final List<StringLabeledField> phones = [];
    final List<StringLabeledField> emails = [];
    final List<AddressLabeledField> addresses = [];
    for (final String fieldLine in contactFieldLines) {
      await processContactFieldLine(res, phones, emails, addresses, fieldLine);
    }
    res.setPhoneInfos(phones);
    res.setEmailInfos(emails);
    res.setAddressInfos(addresses);
    return res;
  }
}
