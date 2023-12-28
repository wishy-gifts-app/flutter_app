import 'package:Wishy/models/utils.dart';

class Follower {
  final int? id;
  final String name;
  final String phoneNumber;

  Follower({this.id, required this.name, required this.phoneNumber});

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: convertValue<int?>(json, 'id', false),
      name: convertValue<String>(json, 'name', true, defaultValue: ""),
      phoneNumber:
          convertValue<String>(json, 'phone_number', true, defaultValue: ""),
    );
  }
}
