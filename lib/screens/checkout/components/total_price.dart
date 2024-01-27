import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class TotalPriceWidget extends StatelessWidget {
  final String productTitle;
  final String? variantDescription;
  final Variant variant;
  final double? deliveryPrice, saleTax;
  final bool enable;

  TotalPriceWidget({
    required this.variant,
    required this.productTitle,
    required this.saleTax,
    this.deliveryPrice,
    required this.enable,
    this.variantDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 110,
        ),
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  padding: EdgeInsets.all(0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontFamily: "Muli",
                          color: Colors.black,
                          letterSpacing: 0.4,
                          height: 1.2),
                      children: <TextSpan>[
                        TextSpan(
                          text: productTitle,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (variantDescription != "" &&
                            variantDescription != null) ...[
                          TextSpan(
                            text: ", $variantDescription",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ],
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${marketDetails["symbol"]}${variant.price}",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                )
              ]),
          SizedBox(
            height: getProportionateScreenHeight(1),
          ),
          // if (deliveryPrice != null && deliveryPrice! > 0) ...[
          //   SizedBox(
          //     height: getProportionateScreenHeight(7),
          //   ),
          //   Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Text(
          //           "Delivery Price:",
          //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          //         ),
          //         Text(
          //           "${marketDetails["symbol"]}${deliveryPrice}",
          //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          //           maxLines: 4,
          //         )
          //       ])
          // ],
          SizedBox(
            height: getProportionateScreenHeight(7),
          ),
          if (saleTax != null && saleTax! > 0)
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Collected Tax:",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${marketDetails["symbol"]}${saleTax}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 4,
                  )
                ]),
        ]));
  }
}
