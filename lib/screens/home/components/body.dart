import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'home_header.dart';
import 'popular_product.dart';

class Body extends StatelessWidget {
  final double headerHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          HomeHeader(height: headerHeight),
          Expanded(
            child: PopularProducts(height: headerHeight),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
