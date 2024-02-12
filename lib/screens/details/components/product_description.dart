import 'package:Wishy/components/delivery_availability_icon.dart';
import 'package:Wishy/components/top_rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Wishy/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  ProductDescription({
    Key? key,
    required this.product,
    required this.childBuilder,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;
  final Widget Function(Color) childBuilder;

  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);

  @override
  Widget build(BuildContext context) {
    return TopRoundedContainer(
        color: firstColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.likedByUserName != null) ...[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: kAlertColor, width: 2),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.5),
                      //     spreadRadius: 1,
                      //     blurRadius: 2,
                      //     offset: Offset(0, 1),
                      //   ),
                      // ],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        colorFilter:
                            ColorFilter.mode(kAlertColor, BlendMode.srcIn),
                        height: getProportionateScreenWidth(16),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(5),
                      ),
                      Text(
                        "${product.likedByUserName} Wishes",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAlertColor,
                          fontSize: 11,
                        ),
                      ),
                    ]),
                  )),
              SizedBox(height: getProportionateScreenHeight(5))
            ],
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Text(
                product.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: DeliveryAvailabilityIcon(withBackground: false)),
                  SizedBox(
                    width: getProportionateScreenWidth(7),
                  ),
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    if (product.shipping?["details"] != null) ...[
                      Icon(Icons.local_shipping, color: kAlertColor, size: 16),
                      Text(product.shipping!["details"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kAlertColor,
                              fontSize: 13,
                              letterSpacing: 0.4,
                              height: 1.2)),
                      SizedBox(height: 2),
                    ],
                    if (product.refound != null)
                      Text(product.refound!,
                          style: TextStyle(
                              color: kAlertColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                  ])
                ]),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: getProportionateScreenWidth(20),
                  right: getProportionateScreenWidth(64),
                  top: 5,
                  bottom: 20),
              child: Text(
                product.description ?? "",
                maxLines: 2,
              ),
            ),
            if (product.additionalData.anotherDetails != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: 10,
                ),
                child: GestureDetector(
                  onTap: pressOnSeeMore,
                  child: Row(
                    children: [
                      Text(
                        "See More Detail",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kPrimaryColor),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: kPrimaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            TopRoundedContainer(
                color: secondColor,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Our Recommendations:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            ...product.additionalData.aiRecommendations
                                .map((v) => Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/Wishy AI.png",
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(child: Text(v)),
                                      ],
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                      childBuilder(firstColor),
                    ]))
          ],
        ));
  }
}
