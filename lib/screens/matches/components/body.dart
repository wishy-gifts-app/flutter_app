import 'matches_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'matches_product.dart';

class Body extends StatelessWidget {
  final double headerHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          MatchesHeader(height: headerHeight),
          Expanded(
            child: MatchesProducts(
              isLike: false,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
