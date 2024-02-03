import 'package:Wishy/components/delivery_availability_icon.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Wishy/models/Product.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.likedByUserName != null) ...[
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SvgPicture.asset(
                    "assets/icons/Heart Icon_2.svg",
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: getProportionateScreenWidth(16),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(5),
                  ),
                  Text(
                    "${product.likedByUserName} Wishes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ]),
              )),
          SizedBox(height: getProportionateScreenHeight(5))
        ],
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(15)),
            width: getProportionateScreenWidth(
                GlobalManager().isDeliveryAvailable ?? true ? 60 : 100),
            decoration: BoxDecoration(
              color: Color(0xFFF5F6F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Row(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: DeliveryAvailabilityIcon(withBackground: false)),
              SizedBox(
                width: getProportionateScreenWidth(7),
              ),
              SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                colorFilter: ColorFilter.mode(
                    product.isLike == true ? Colors.red : Color(0xFFDBDEE4),
                    BlendMode.srcIn),
                height: getProportionateScreenWidth(16),
              ),
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(64),
          ),
          child: Text(
            product.description ?? "",
            maxLines: 3,
          ),
        ),
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
        )
      ],
    );
  }
}
