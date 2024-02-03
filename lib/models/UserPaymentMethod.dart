import 'utils.dart';

enum PaymentMethods { card, google_pay, cash_app, new_version }

PaymentMethods getPaymentMethodFromString(String methodString) {
  for (var method in PaymentMethods.values) {
    if (method.name == methodString) {
      return method;
    }
  }
  return PaymentMethods.new_version;
}

class UserPaymentMethod {
  final PaymentMethods method;
  final int userId;
  final int? id;
  final String? paymentId, lastDigits;
  final bool saved;
  final DateTime? lastUpdatedAt;

  UserPaymentMethod({
    required this.method,
    required this.userId,
    this.id,
    this.paymentId,
    this.lastDigits,
    this.lastUpdatedAt,
    this.saved = true,
  });

  factory UserPaymentMethod.fromJson(Map<String, dynamic> json) {
    return UserPaymentMethod(
      userId: convertValue<int>(json, 'user_id', true),
      method: getPaymentMethodFromString(json["method"]),
      id: convertValue<int?>(json, 'id', false),
      paymentId: convertValue<String?>(json, 'payment_id', false),
      lastDigits: convertValue<String?>(json, 'last_digits', false),
      lastUpdatedAt: convertValue<DateTime?>(json, 'last_updated_at', false),
    );
  }
}
