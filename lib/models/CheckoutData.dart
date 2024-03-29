import 'package:Wishy/models/utils.dart';

class CheckoutData {
  final String deliveryTime, paymentId, clientSecret, additionalHighlights;
  final double deliveryPrice, saleTax, totalPrice;
  final int payAmount;

  CheckoutData(
      {required this.additionalHighlights,
      required this.deliveryTime,
      required this.paymentId,
      required this.clientSecret,
      required this.totalPrice,
      required this.payAmount,
      required this.saleTax,
      required this.deliveryPrice});

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      deliveryTime: convertValue<String>(json, 'delivery_time', false),
      additionalHighlights: convertValue<String>(
          json, 'additional_highlights', true,
          defaultValue: ""),
      deliveryPrice: convertValue<double>(json, 'delivery_price', true),
      totalPrice: convertValue<double>(json, 'total_price', true),
      payAmount: convertValue<int>(json, 'pay_amount', true),
      saleTax: convertValue<double>(json, 'sale_tax', true),
      paymentId: convertValue<String>(json, 'payment_id', true),
      clientSecret: convertValue<String>(json, 'client_secret', true),
    );
  }
}
