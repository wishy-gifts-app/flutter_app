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
  final bool isOrderCompleted;
  final bool isOrderApproved;
  final bool isInDelivery;
  final DateTime? forDate;
  final Product product;

  Order(
      {required this.id,
      required this.userId,
      required this.productId,
      required this.variantId,
      required this.price,
      required this.isOrderCompleted,
      required this.isOrderApproved,
      required this.isInDelivery,
      required this.product,
      this.recipientUserId,
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
      isOrderCompleted: convertValue<bool>(json, 'is_order_completed', true),
      isInDelivery: convertValue<bool>(json, 'is_in_delivery', true),
      isOrderApproved: convertValue<bool>(json, 'is_order_approved', true),
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
