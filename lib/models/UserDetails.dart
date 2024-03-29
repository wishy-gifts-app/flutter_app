import 'package:Wishy/models/Address.dart';
import 'package:Wishy/models/UserPaymentMethod.dart';
import 'utils.dart';

class UserDetails {
  final int id;
  final String? name;
  final String? phoneNumber;
  final String? email;
  final List<Address>? addresses;
  List<UserPaymentMethod> paymentMethods;

  UserDetails(
      {required this.id,
      this.name,
      this.email,
      this.phoneNumber,
      required this.paymentMethods,
      this.addresses});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: convertValue<int>(json, 'id', true),
      name: convertValue<String?>(json, 'name', false),
      phoneNumber: convertValue<String?>(json, 'phone_number', false),
      email: convertValue<String?>(json, 'email', false),
      addresses: json["addresses"] != null
          ? (json["addresses"] as List<dynamic>)
              .map((item) => Address.fromJson(item))
              .toList()
          : null,
      paymentMethods: (json["payment_methods"] as List<dynamic>)
          .map((item) => UserPaymentMethod.fromJson(item))
          .toList(),
    );
  }
}
