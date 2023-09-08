import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

import 'components/body.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  final Variant variant;
  final int orderId;

  CheckoutScreen({required this.variant, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Body(),
    );
  }
}
