import 'package:po_contacts_flutter/utils/utils.dart';

class AddressInfo {
  static const String FIELD_POST_OFFICE_BOX = 'post_office_box';
  static const String FIELD_EXTENDED_ADDRESS = 'extended_address';
  static const String FIELD_STREET_ADDRESS = 'street_address';
  static const String FIELD_LOCALITY = 'locality';
  static const String FIELD_REGION = 'region';
  static const String FIELD_POSTAL_CODE = 'postal_code';
  static const String FIELD_COUNTRY = 'country';

  //the post office box
  final String postOfficeBox;
  //the extended address
  final String extendedAddress;
  //the street address
  final String streetAddress;
  //the locality (e.g., city);
  final String locality;
  //the region (e.g., state or province);
  final String region;
  //the postal code;
  final String postalCode;
  //the country name
  final String country;

  AddressInfo(
    final String postOfficeBox,
    final String extendedAddress,
    final String streetAddress,
    final String locality,
    final String region,
    final String postalCode,
    final String country,
  )   : this.postOfficeBox = postOfficeBox ?? '',
        this.extendedAddress = extendedAddress ?? '',
        this.streetAddress = streetAddress ?? '',
        this.locality = locality ?? '',
        this.region = region ?? '',
        this.postalCode = postalCode ?? '',
        this.country = country ?? '';

  NormalizedString _nPostOfficeBox;
  NormalizedString get nPostOfficeBox {
    if (_nPostOfficeBox == null) {
      _nPostOfficeBox = NormalizedString(postOfficeBox);
    }
    return _nPostOfficeBox;
  }

  NormalizedString _nExtendedAddress;
  NormalizedString get nExtendedAddress {
    if (_nExtendedAddress == null) {
      _nExtendedAddress = NormalizedString(extendedAddress);
    }
    return _nExtendedAddress;
  }

  NormalizedString _nStreetAddress;
  NormalizedString get nStreetAddress {
    if (_nStreetAddress == null) {
      _nStreetAddress = NormalizedString(streetAddress);
    }
    return _nStreetAddress;
  }

  NormalizedString _nLocality;
  NormalizedString get nLocality {
    if (_nLocality == null) {
      _nLocality = NormalizedString(locality);
    }
    return _nLocality;
  }

  NormalizedString _nRegion;
  NormalizedString get nRegion {
    if (_nRegion == null) {
      _nRegion = NormalizedString(region);
    }
    return _nRegion;
  }

  NormalizedString _nPostalCode;
  NormalizedString get nPostalCode {
    if (_nPostalCode == null) {
      _nPostalCode = NormalizedString(postalCode);
    }
    return _nPostalCode;
  }

  NormalizedString _nCountry;
  NormalizedString get nCountry {
    if (_nCountry == null) {
      _nCountry = NormalizedString(country);
    }
    return _nCountry;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FIELD_POST_OFFICE_BOX: postOfficeBox,
      FIELD_EXTENDED_ADDRESS: extendedAddress,
      FIELD_STREET_ADDRESS: streetAddress,
      FIELD_LOCALITY: locality,
      FIELD_REGION: region,
      FIELD_POSTAL_CODE: postalCode,
      FIELD_COUNTRY: country,
    };
  }

  static AddressInfo fromMap(final dynamic fieldValue) {
    return AddressInfo(
      fieldValue[FIELD_POST_OFFICE_BOX],
      fieldValue[FIELD_EXTENDED_ADDRESS],
      fieldValue[FIELD_STREET_ADDRESS],
      fieldValue[FIELD_LOCALITY],
      fieldValue[FIELD_REGION],
      fieldValue[FIELD_POSTAL_CODE],
      fieldValue[FIELD_COUNTRY],
    );
  }

  static bool _addString(final StringBuffer stringBuffer, final String str, final bool hasPreceedingText) {
    if (str.trim().isNotEmpty) {
      if (hasPreceedingText) {
        stringBuffer.write('\n');
      }
      stringBuffer.write(str.trim());
      return true;
    }
    return hasPreceedingText;
  }

  @override
  String toString() {
    final StringBuffer res = StringBuffer();
    bool addedText = false;
    addedText = _addString(res, postOfficeBox, addedText);
    addedText = _addString(res, extendedAddress, addedText);
    addedText = _addString(res, streetAddress, addedText);
    addedText = _addString(res, locality, addedText);
    addedText = _addString(res, region, addedText);
    addedText = _addString(res, postalCode, addedText);
    addedText = _addString(res, country, addedText);
    return res.toString();
  }

  static bool areEqual(final AddressInfo item1, final AddressInfo item2) {
    if (item1 == item2) {
      return true;
    }
    if (item1 == null || item2 == null) {
      return false;
    }
    if (item1.postOfficeBox != item2.postOfficeBox) return false;
    if (item1.extendedAddress != item2.extendedAddress) return false;
    if (item1.streetAddress != item2.streetAddress) return false;
    if (item1.locality != item2.locality) return false;
    if (item1.region != item2.region) return false;
    if (item1.postalCode != item2.postalCode) return false;
    if (item1.country != item2.country) return false;
    return true;
  }
}
