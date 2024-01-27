import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Variant variant;

  ProductWidget({required this.product, required this.variant});

  @override
  Widget build(BuildContext context) {
    final String image = product.images
        .firstWhere((element) => element.variantId == variant.id,
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
          // SizedBox(
          //   height: getProportionateScreenHeight(5),
          // ),
          // Text(
          //   product.title,
          //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          //   textAlign: TextAlign.center,
          //   maxLines: 4,
          // ),
          // if (variantDescription != "") ...[
          //   SizedBox(
          //     height: getProportionateScreenHeight(2),
          //   ),
          //   Text(
          //     variantDescription,
          //     style: TextStyle(fontSize: 12),
          //     textAlign: TextAlign.center,
          //     maxLines: 4,
          //   )
          // ]
        ]));
  }
}
