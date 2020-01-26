import 'package:po_contacts_flutter/utils/utils.dart';

class AddressInfo {
  static const String FIELD_STREET_ADDRESS = 'street_address';
  static const String FIELD_LOCALITY = 'locality';
  static const String FIELD_REGION = 'region';
  static const String FIELD_POSTAL_CODE = 'postal_code';
  static const String FIELD_COUNTRY = 'country';

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
    this.streetAddress,
    this.locality,
    this.region,
    this.postalCode,
    this.country,
  );

  NormalizedString _nStreetAddress;
  NormalizedString get nStreetAddress => _getNStreetAddress();
  NormalizedString _getNStreetAddress() {
    if (_nStreetAddress == null) {
      _nStreetAddress = NormalizedString(streetAddress);
    }
    return _nStreetAddress;
  }

  NormalizedString _nLocality;
  NormalizedString get nLocality => _getNLocality();
  NormalizedString _getNLocality() {
    if (_nLocality == null) {
      _nLocality = NormalizedString(locality);
    }
    return _nLocality;
  }

  NormalizedString _nRegion;
  NormalizedString get nRegion => _getNRegion();
  NormalizedString _getNRegion() {
    if (_nRegion == null) {
      _nRegion = NormalizedString(region);
    }
    return _nRegion;
  }

  NormalizedString _nPostalCode;
  NormalizedString get nPostalCode => _getNPostalCode();
  NormalizedString _getNPostalCode() {
    if (_nPostalCode == null) {
      _nPostalCode = NormalizedString(postalCode);
    }
    return _nPostalCode;
  }

  NormalizedString _nCountry;
  NormalizedString get nCountry => _getNCountry();
  NormalizedString _getNCountry() {
    if (_nCountry == null) {
      _nCountry = NormalizedString(country);
    }
    return _nCountry;
  }

  Map<String, dynamic> toMap() {
    return {
      FIELD_STREET_ADDRESS: streetAddress,
      FIELD_LOCALITY: locality,
      FIELD_REGION: region,
      FIELD_POSTAL_CODE: postalCode,
      FIELD_COUNTRY: country,
    };
  }

  static AddressInfo fromMap(final dynamic fieldValue) {
    return AddressInfo(
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
    addedText = _addString(res, streetAddress, addedText);
    addedText = _addString(res, locality, addedText);
    addedText = _addString(res, region, addedText);
    addedText = _addString(res, postalCode, addedText);
    addedText = _addString(res, country, addedText);
    return res.toString();
  }

  @override
  int get hashCode {
    return 3 * streetAddress.hashCode + //
        7 * locality.hashCode + //
        11 * region.hashCode + //
        13 * postalCode.hashCode + //
        17 * country.hashCode + //
        0;
  }

  bool operator ==(o) {
    if (o is AddressInfo) {
      return streetAddress == o.streetAddress && //
              locality == o.locality && //
              region == o.region && //
              postalCode == o.postalCode && //
              country == o.country //
          ;
    }
    return false;
  }
}
