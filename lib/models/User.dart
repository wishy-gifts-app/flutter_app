import 'utils.dart';

class User {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: convertValue<int>(json, 'id', true),
      name: convertValue<String>(json, 'name', true),
      phoneNumber: convertValue<String>(json, 'phone_number', true),
      email: convertValue<String>(json, 'email', true),
    );
  }
}
