import 'package:Wishy/models/utils.dart';

class Follower {
  final int id;
  final String name;
  final String phoneNumber;

  Follower({required this.id, required this.name, required this.phoneNumber});

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: convertValue<int>(json, 'id', true),
      name: convertValue<String>(json, 'name', true),
      phoneNumber: convertValue<String>(json, 'phone_number', true),
    );
  }
}
