import 'package:Wishy/models/Address.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/models/utils.dart';

class StageData {
  final String title, subtitle;

  StageData({required this.title, required this.subtitle});

  factory StageData.fromJson(Map<String, dynamic> json) {
    return StageData(
      title: convertValue<String>(json, 'title', true),
      subtitle: convertValue<String>(json, 'subtitle', true),
    );
  }
}

class Order {
  final int id;
  final int userId;
  final int productId;
  final int variantId;
  final int? recipientUserId;
  final String? recipientUserName, trackUri, trackMessage;
  final StageData? receiveStage, deliverStage, approveStage;
  final double price;
  final DateTime? closedAt, arrivedAt, paidAt, approvedAt, deliveredAt;
  final DateTime? forDate;
  final Product product;
  final Address address;

  Order(
      {required this.id,
      required this.userId,
      required this.productId,
      required this.variantId,
      required this.price,
      required this.product,
      required this.address,
      this.recipientUserId,
      this.trackUri,
      this.trackMessage,
      this.receiveStage,
      this.approveStage,
      this.deliverStage,
      this.approvedAt,
      this.deliveredAt,
      this.arrivedAt,
      this.closedAt,
      this.paidAt,
      this.recipientUserName,
      this.forDate});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      address: Address.fromJson(json["address"]),
      product: Product.fromJson(json["product"]),
      id: convertValue<int>(json, 'id', true),
      userId: convertValue<int>(json, 'user_id', true),
      productId: convertValue<int>(json, 'product_id', true),
      variantId: convertValue<int>(json, 'variant_id', true),
      price: convertValue<double>(json, 'price', true),
      paidAt: convertValue<DateTime?>(json, 'paid_at', false),
      closedAt: convertValue<DateTime?>(json, 'closed_at', false),
      arrivedAt: convertValue<DateTime?>(json, 'arrived_at', false),
      deliveredAt: convertValue<DateTime?>(json, 'delivered_at', false),
      approvedAt: convertValue<DateTime?>(json, 'approved_at', false),
      recipientUserId: convertValue<int?>(
        json,
        'recipient_user_id',
        false,
      ),
      trackUri: convertValue<String?>(json, 'track_uri', false),
      trackMessage: convertValue<String?>(json, 'track_message', false),
      recipientUserName:
          convertValue<String?>(json, 'recipient_user_name', false),
      receiveStage: json['receive_stage'] != null
          ? StageData.fromJson(json['receive_stage'])
          : null,
      deliverStage: json['deliver_stage'] != null
          ? StageData.fromJson(json['deliver_stage'])
          : null,
      approveStage: json['approve_stage'] != null
          ? StageData.fromJson(json['approve_stage'])
          : null,
      forDate: convertValue<DateTime?>(json, 'for_date', false),
    );
  }
}
