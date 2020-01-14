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
    if (fieldValue is Map<String, String>) {
      return AddressInfo(
        fieldValue[FIELD_STREET_ADDRESS],
        fieldValue[FIELD_LOCALITY],
        fieldValue[FIELD_REGION],
        fieldValue[FIELD_POSTAL_CODE],
        fieldValue[FIELD_COUNTRY],
      );
    } else {
      return null;
    }
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
}
