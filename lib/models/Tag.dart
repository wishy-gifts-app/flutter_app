import 'utils.dart';

class Tag {
  final String value;
  final int id;

  Tag({
    required this.id,
    required this.value,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      value: convertValue<String>(json, 'value', true),
      id: convertValue<int>(json, 'id', true),
    );
  }
}
