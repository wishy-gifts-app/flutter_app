import 'package:Wishy/components/delivery_availability_icon.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class ProductPrice extends StatelessWidget {
  final Product product;
  final double fontSize;

  ProductPrice({
    Key? key,
    required this.product,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DeliveryAvailabilityIcon(
            size: fontSize * 1.25,
          ),
          if (product.shipping?["card"] != null)
            Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.local_shipping,
                      color: kShippingColor, size: fontSize),
                  SizedBox(width: 4),
                  Text(product.shipping!["card"],
                      style: TextStyle(
                          color: kShippingColor, fontSize: fontSize * 0.8)),
                ])),
          Padding(
              padding: EdgeInsets.only(left: 6),
              child: RoundedBackgroundText.rich(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${marketDetails["symbol"]}${product.price} ",
                      style: TextStyle(
                        fontFamily: "Muli",
                        color: Colors.black,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    if (product.originalPrice != null)
                      TextSpan(
                        text: "${product.originalPrice}",
                        style: TextStyle(
                          fontFamily: "Muli",
                          decoration: TextDecoration.lineThrough,
                          decorationColor: kPrimaryLightColor,
                          color: kPrimaryLightColor,
                          decorationThickness: 2,
                          fontSize: fontSize * 0.75,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                backgroundColor: Colors.white.withOpacity(0.6),
              )),
        ],
      ),
    );
  }
}
