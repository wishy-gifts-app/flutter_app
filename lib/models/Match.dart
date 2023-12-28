import 'package:Wishy/models/Product.dart';
import 'package:Wishy/models/utils.dart';

class Match extends Identifiable {
  final int id;
  final DateTime? displayedAt;
  final Product product;

  Match({required this.id, this.displayedAt = null, required this.product});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: convertValue<int>(json, 'id', true),
      displayedAt: convertValue<DateTime?>(json, 'displayed_at', false),
      product: Product.fromJson(json),
    );
  }
}
