import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

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
    final variant = product.variants?.firstWhere(
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
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              if (variant?.title != null) ...[
                RoundedBackgroundText(
                  variant!.title,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontFamily: 'Muli'),
                ),
                SizedBox(
                  height: 4,
                )
              ],
              if (product.images.isNotEmpty)
                Image.network(
                  variant?.image?.url ?? product.images[0].url,
                  fit: BoxFit.contain,
                  height: 90,
                )
              else
                Text("Image not available"),
              SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    product.title,
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  )),
              Text("${marketDetails["symbol"]}${price}"),
            ],
          ),
        ]));
  }
}
