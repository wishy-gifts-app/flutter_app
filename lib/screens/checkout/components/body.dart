import 'package:Wishy/screens/checkout/components/purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
// import 'package:Wishy/screens/checkout/components/buy_as_gift_form.dart';
// import 'package:Wishy/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:Wishy/size_config.dart';

class Body extends StatelessWidget {
  final Variant variant;
  final int productId;
  final int? recipientId;

  Body({required this.variant, required this.productId, this.recipientId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          // SizedBox(height: getProportionateScreenHeight(10)),
          Text("Complete Purchase", style: headingStyle),
          SizedBox(height: getProportionateScreenHeight(20)),
          PurchaseForm(
              variantId: variant.id,
              recipientId: recipientId,
              price: variant.price),
        ],
      ),
    )));
  }
}
