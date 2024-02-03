import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Variant variant;

  ProductWidget({required this.product, required this.variant});

  @override
  Widget build(BuildContext context) {
    final String image = product.images
        .firstWhere(
            (element) =>
                variant.imageId != null && element.id == variant.imageId,
            orElse: () => product.images[0])
        .url;

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
