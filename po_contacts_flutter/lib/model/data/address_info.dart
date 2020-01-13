class AddressInfo {
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
}
