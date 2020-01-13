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
}
