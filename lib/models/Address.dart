import 'package:shop_app/models/utils.dart';

class Address {
  final int id;
  final String country;
  final String state;
  final String city;
  final String streetAddress;
  final String streetNumber;
  final String zipCode;
  final String? apartment;
  final String? extraDetails;

  Address({
    required this.id,
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
      'id': id,
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: convertValue<int>(json, 'id', true),
      country: convertValue<String>(json, 'country', true),
      state: convertValue<String>(json, 'state', true),
      streetAddress: convertValue<String>(json, 'street_address', true),
      streetNumber: convertValue<String>(json, 'street_number', true),
      city: convertValue<String>(json, 'city', true),
      zipCode: convertValue<String>(json, 'zip_code', false),
      apartment: convertValue<String>(json, 'apartment', false),
      extraDetails: convertValue<String>(json, 'extra_details', false),
    );
  }
}
