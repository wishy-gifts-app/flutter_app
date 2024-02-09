import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  final Product product;
  final Variant? variant;

  ProductImageWidget({required this.product, required this.variant});

  @override
  Widget build(BuildContext context) {
    final String image = variant?.image?.url ?? product.images[0].url;

    return Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: Column(children: [
          Image.network(
            image,
            height: 120,
            fit: BoxFit.cover,
          ),
        ]));
  }
}
