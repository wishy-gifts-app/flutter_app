import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';

import 'components/body.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  final Variant variant;
  final int productId;
  final int? recipientId;

  CheckoutScreen(
      {required this.variant, required this.productId, this.recipientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Body(
        variant: variant,
        productId: productId,
        recipientId: recipientId,
      ),
    );
  }
}
