import 'package:Wishy/models/utils.dart';

class Address {
  final int id;
  final String country;
  final String countryCode;
  final String state;
  final String name;
  final String phoneNumber;
  final String city;
  final String streetAddress;
  final String streetNumber;
  final String zipCode;
  final String? apartment;
  final String? extraDetails;
  final bool allowShare;
  final int? createdUserId;

  Address({
    required this.id,
    required this.country,
    required this.countryCode,
    required this.name,
    required this.phoneNumber,
    required this.state,
    required this.streetAddress,
    required this.streetNumber,
    required this.zipCode,
    required this.city,
    required this.allowShare,
    required this.createdUserId,
    this.apartment,
    this.extraDetails,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'country': country,
  //     'countryCode': countryCode,
  //     'state': state,
  //     'streetAddress': streetAddress,
  //     'streetNumber': streetNumber,
  //     'zipCode': zipCode,
  //     'apartment': apartment,
  //     'city': city,
  //     'extraDetails': extraDetails,
  //   };
  // }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: convertValue<int>(json, 'id', true),
      country: convertValue<String>(json, 'country', true),
      name: convertValue<String>(json, 'name', true),
      phoneNumber: convertValue<String>(json, 'phone_number', true),
      countryCode: convertValue<String>(json, 'country_code', true),
      state: convertValue<String>(json, 'state', true),
      streetAddress: convertValue<String>(json, 'street_address', true),
      streetNumber: convertValue<String>(json, 'street_number', true),
      city: convertValue<String>(json, 'city', true),
      zipCode: convertValue<String>(json, 'zip_code', false),
      apartment: convertValue<String>(json, 'apartment', false),
      extraDetails: convertValue<String>(json, 'extra_details', false),
      allowShare:
          convertValue<bool>(json, 'allow_share', false, defaultValue: false),
      createdUserId: convertValue<int?>(json, 'created_user_id', false),
    );
  }
}
