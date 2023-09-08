class Address {
  final String country;
  final String state;
  final String city;
  final String streetAddress;
  final String streetNumber;
  final String zipCode;
  final String? apartment;
  final String? extraDetails;

  Address({
    required this.country,
    required this.state,
    required this.streetAddress,
    required this.streetNumber,
    required this.zipCode,
    required this.city,
    this.apartment,
    this.extraDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'state': state,
      'streetAddress': streetAddress,
      'streetNumber': streetNumber,
      'zipCode': zipCode,
      'apartment': apartment,
      'city': city,
      'extraDetails': extraDetails,
    };
  }

  static Address fromMap(Map<String, dynamic> map) {
    return Address(
      country: map['country'],
      state: map['state'],
      streetAddress: map['streetAddress'],
      streetNumber: map['streetNumber'],
      zipCode: map['zipCode'],
      apartment: map['apartment'],
      city: map['city'],
      extraDetails: map['extraDetails'],
    );
  }
}
