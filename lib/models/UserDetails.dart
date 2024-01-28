import 'package:Wishy/models/Address.dart';

import 'utils.dart';

class UserDetails {
  final int id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final List<Address>? addresses;

  UserDetails(
      {required this.id,
      this.name,
      this.email,
      this.phoneNumber,
      this.addresses});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: convertValue<int>(json, 'id', true),
      name: convertValue<String>(json, 'name', true),
      phoneNumber: convertValue<String>(json, 'phone_number', true),
      email: convertValue<String>(json, 'email', true),
      addresses: json["addresses"] != null
          ? (json["addresses"] as List<dynamic>)
              .map((item) => Address.fromJson(item))
              .toList()
          : null,
    );
  }
}
