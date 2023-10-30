import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/models/utils.dart';

enum RequestType {
  userRequest,
  requestFromUser,
}

class Request extends Identifiable {
  final int id;
  final String reason;
  final DateTime createdAt;
  final int productId, variantId, requesterId, recipientId;
  final String otherUserName;
  final Product product;
  final RequestType type;

  Request({
    required this.id,
    required this.reason,
    required this.createdAt,
    required this.productId,
    required this.recipientId,
    required this.requesterId,
    required this.variantId,
    required this.otherUserName,
    required this.product,
    required this.type,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: convertValue<int>(json, 'id', true),
      reason: convertValue<String>(json, 'reason', true),
      createdAt: convertValue<DateTime>(json, 'created_at', true),
      productId: convertValue<int>(json, 'product_id', true),
      variantId: convertValue<int>(json, 'variant_id', true),
      requesterId: convertValue<int>(json, 'requester_id', true),
      recipientId: convertValue<int>(json, 'recipient_id', true),
      otherUserName: convertValue<String>(json, 'other_user_name', true),
      product: Product.fromJson(json['product']),
      type: json['requester_id'] == GlobalManager().userId
          ? RequestType.userRequest
          : RequestType.requestFromUser,
    );
  }
}
