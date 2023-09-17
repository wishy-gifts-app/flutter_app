import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';

class HistoryProductCard extends StatelessWidget {
  final Product product;
  final int variantId;
  final double price;
  final String? recipientUserName;

  const HistoryProductCard({
    Key? key,
    required this.product,
    required this.variantId,
    required this.price,
    required this.recipientUserName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final variant = product.variants.firstWhere(
      (element) => element.id == variantId,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (recipientUserName != null && recipientUserName!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Gift for: ${recipientUserName}",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (recipientUserName == null || recipientUserName!.isEmpty)
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
          if (product.images.isNotEmpty)
            Image.network(
              product.images
                  .firstWhere((element) => element.variantId == variantId,
                      orElse: () => product.images[0])
                  .url,
              fit: BoxFit.contain,
              height: 80,
            )
          else
            Text("Image not available"),
          SizedBox(height: 10),
          Text(
            product.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text("\$ ${price}"),
          if (product.variants.length > 1)
            Text(
              variant.title,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
