import 'package:po_contacts_flutter/controller/vcard/field/vcf_field.dart';
import 'package:po_contacts_flutter/controller/vcard/vcf_constants.dart';
import 'package:po_contacts_flutter/controller/vcard/writer/abs_file_reader.dart';
import 'package:po_contacts_flutter/model/data/address_info.dart';
import 'package:po_contacts_flutter/model/data/address_labeled_field.dart';
import 'package:po_contacts_flutter/model/data/contact.dart';
import 'package:po_contacts_flutter/model/data/labeled_field.dart';
import 'package:po_contacts_flutter/model/data/string_labeled_field.dart';
import 'package:po_contacts_flutter/utils/utils.dart';

abstract class VCFWriter {
  final FileReader fileReader;

  VCFWriter(this.fileReader);

  void writeStringImpl(final String line);

  void writeLine(final String line) {
    //We choose to not respect the "Line Delimiting and Folding" strictly:
    //https://tools.ietf.org/html/rfc6350#section-3.2
    //It seems the rationale behind having adding this complication is "older software support".
    //If the need arises, this can easily be updated and users can re-exported later after app update,
    //since the read functionality handles any line sizes.
    writeStringImpl(line + VCFConstants.VCF_LINE_RETURN_FIELD_SEPARATION);
  }

  String _escapeStringToVCF(final String str) {
    String res = str;
    VCFConstants.VCF_ESCAPED_CHARS_MAP.forEach((key, value) {
      res = res.replaceAll(key, value);
    });
    return res;
  }

  void _writeVCFFieldLabelParam(final StringBuffer output, final VCFFieldLabelParamValue labelParamValue) {
    if (labelParamValue == null) {
      return;
    }
    output.write(VCFConstants.VCF_SEPARATOR_SEMICOLON);
    if (labelParamValue.labelType == LabeledFieldLabelType.custom) {
      output.write('X-');
      output.write(_escapeStringToVCF(labelParamValue.labelText));
    } else {
      output.write(
        LabeledField.labeledFieldLabelTypeToString(labelParamValue.labelType).toUpperCase(),
      );
    }
  }

  void _writeVCFPhotoParams(StringBuffer output, String photoFileExtension) {
    if (photoFileExtension == null) {
      return;
    }
    output.write(VCFConstants.VCF_SEPARATOR_SEMICOLON);
    output.write('ENCODING=BASE64');
    output.write(VCFConstants.VCF_SEPARATOR_SEMICOLON);
    final String pictureTypeString = photoFileExtension == '.png' ? 'PNG' : 'JPEG';
    output.write(pictureTypeString);
  }

  void _writeVCFStringFieldValue(
    final String fieldName,
    final String fieldValue, {
    final VCFFieldLabelParamValue labelParamValue,
    final String photoFileExtension,
    final bool writeEmpty = false,
  }) {
    if (!writeEmpty && fieldValue.trim().isEmpty) {
      return;
    }
    final StringBuffer res = StringBuffer();
    res.write(fieldName);
    _writeVCFFieldLabelParam(res, labelParamValue);
    _writeVCFPhotoParams(res, photoFileExtension);
    res.write(':');
    res.write(_escapeStringToVCF(fieldValue));
    writeLine(res.toString());
  }

  void _writeVCFStringFieldValues(
    final String fieldName,
    final List<String> fieldValues, {
    final VCFFieldLabelParamValue labelParamValue,
    final bool writeEmpty = false,
  }) {
    if (!writeEmpty) {
      bool foundNonEmpty = false;
      for (final String s in fieldValues) {
        if (s.trim().isNotEmpty) {
          foundNonEmpty = true;
          break;
        }
      }
      if (!foundNonEmpty) {
        return;
      }
    }
    final StringBuffer res = StringBuffer();
    res.write(fieldName);
    _writeVCFFieldLabelParam(res, labelParamValue);
    res.write(':');
    bool hasWrittenValue = false;
    for (final String s in fieldValues) {
      if (hasWrittenValue) {
        res.write(VCFConstants.VCF_SEPARATOR_SEMICOLON);
      } else {
        hasWrittenValue = true;
      }
      res.write(_escapeStringToVCF(s));
    }
    writeLine(res.toString());
  }

  Future<void> writeContactFields(final Contact contact) async {
    if (contact.image != null) {
      final String fileExtension = Utils.getFileExtension(contact.image);
      final String photoAsBase64String = await fileReader.fileToBase64String(contact.image);
      if (photoAsBase64String != null) {
        _writeVCFStringFieldValue(
          VCFConstants.FIELD_PHOTO,
          photoAsBase64String,
          photoFileExtension: fileExtension,
        );
      }
    }
    _writeVCFStringFieldValue(
      VCFConstants.FIELD_FULL_NAME,
      contact.fullName,
      writeEmpty: true,
    );
    _writeVCFStringFieldValues(
      VCFConstants.FIELD_NAME,
      [contact.lastName, contact.firstName, '', '', ''],
      writeEmpty: true,
    );
    _writeVCFStringFieldValue(
      VCFConstants.FIELD_NICKNAME,
      contact.nickName,
    );
    for (final AddressLabeledField alf in contact.addressInfos) {
      final AddressInfo addressInfo = alf.fieldValue;
      _writeVCFStringFieldValues(
        VCFConstants.FIELD_ADRESS,
        [
          '',
          '',
          addressInfo.streetAddress,
          addressInfo.locality,
          addressInfo.region,
          addressInfo.postalCode,
          addressInfo.country,
        ],
        labelParamValue: VCFFieldLabelParamValue(alf.labelType, alf.labelText),
      );
    }
    for (final StringLabeledField slf in contact.phoneInfos) {
      _writeVCFStringFieldValue(
        VCFConstants.FIELD_PHONE,
        slf.fieldValue,
        labelParamValue: VCFFieldLabelParamValue(slf.labelType, slf.labelText),
      );
    }
    for (final StringLabeledField slf in contact.emailInfos) {
      _writeVCFStringFieldValue(
        VCFConstants.FIELD_EMAIL,
        slf.fieldValue,
        labelParamValue: VCFFieldLabelParamValue(slf.labelType, slf.labelText),
      );
    }
    _writeVCFStringFieldValues(VCFConstants.FIELD_ORG, [
      contact.organizationName,
      contact.organizationDivision,
      '',
    ]);
    _writeVCFStringFieldValue(
      VCFConstants.FIELD_TITLE,
      contact.organizationTitle,
    );
    _writeVCFStringFieldValue(
      VCFConstants.FIELD_URL,
      contact.website,
    );
    _writeVCFStringFieldValue(
      VCFConstants.FIELD_NOTE,
      contact.notes,
    );
    for (final String extraFieldLine in contact.unknownVCFFieldLines) {
      writeLine(extraFieldLine);
    }
  }

  Future<void> writeContact(final Contact contact) async {
    if (contact == null) {
      return;
    }

    writeLine(VCFConstants.FIELD_BEGIN_VCARD);
    writeLine(VCFConstants.VCF_VERSION_LINE);
    await writeContactFields(contact);
    writeLine(VCFConstants.FIELD_END_VCARD);
    writeLine('');
  }
}
