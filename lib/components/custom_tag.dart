import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTag extends StatelessWidget {
  final Widget icon;
  final Color color;
  final String text;

  CustomTag({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: kAlertColor,
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
        ],
      ),
    );
  }
}

List<Widget> buildProductTags(Product product) {
  final List<Widget> result = [];

  product.tags.forEach((element) {
    if (element.runtimeType == String)
      result.addAll([
        CustomTag(
            text: element,
            icon: Image.asset(
              'assets/images/Wishy AI.png',
              width: 30,
              height: 21,
            ),
            color: Colors.orange),
        SizedBox(
          height: 3,
        )
      ]);
  });

  if (product.likedByUserName != null) {
    result.addAll([
      CustomTag(
          text: "${product.likedByUserName}'s Wishes",
          icon: SvgPicture.asset(
            "assets/icons/Heart Icon_2.svg",
            colorFilter: ColorFilter.mode(kAlertColor, BlendMode.srcIn),
            height: 16,
          ),
          color: kAlertColor),
      SizedBox(
        height: 3,
      )
    ]);
  }

  return result;
}
