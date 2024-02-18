import 'package:Wishy/components/product_image_widget.dart';
import 'package:Wishy/screens/checkout/components/purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';

class Body extends StatelessWidget {
  final Variant variant;
  final Product product;
  final int? recipientId;

  Body({required this.variant, required this.product, this.recipientId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          ProductImageWidget(
            product: product,
            variant: variant,
          ),
          PurchaseForm(
              product: product,
              variantId: variant.id,
              recipientId: recipientId,
              price: variant.price),
        ],
      ),
    ));
  }
}
