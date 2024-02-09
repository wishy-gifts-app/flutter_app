import 'package:Wishy/models/Product.dart';
import 'package:Wishy/models/utils.dart';

class Order {
  final int id;
  final int userId;
  final int productId;
  final int variantId;
  final int? recipientUserId;
  final String? recipientUserName;
  final double price;
  final DateTime? closedAt, arrivedAt, paidAt, approvedAt;
  final DateTime? forDate;
  final Product product;

  Order(
      {required this.id,
      required this.userId,
      required this.productId,
      required this.variantId,
      required this.price,
      required this.product,
      this.recipientUserId,
      this.approvedAt,
      this.arrivedAt,
      this.closedAt,
      this.paidAt,
      this.recipientUserName,
      this.forDate});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      product: Product.fromJson(json["product"]),
      id: convertValue<int>(json, 'id', true),
      userId: convertValue<int>(json, 'user_id', true),
      productId: convertValue<int>(json, 'product_id', true),
      variantId: convertValue<int>(json, 'variant_id', true),
      price: convertValue<double>(json, 'price', true),
      paidAt: convertValue<DateTime?>(json, 'paid_at', false),
      closedAt: convertValue<DateTime?>(json, 'closed_at', false),
      arrivedAt: convertValue<DateTime?>(json, 'arrived_at', false),
      approvedAt: convertValue<DateTime?>(json, 'approved_at', false),
      recipientUserId: convertValue<int?>(
        json,
        'recipient_user_id',
        false,
      ),
      recipientUserName:
          convertValue<String?>(json, 'recipient_user_name', false),
      forDate: convertValue<DateTime?>(json, 'for_date', false),
    );
  }
}
