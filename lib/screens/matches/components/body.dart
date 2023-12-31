import 'matches_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'matches_product.dart';

class Body extends StatelessWidget {
  final double headerHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          MatchesHeader(height: headerHeight),
          Expanded(
            child: MatchesProducts(),
          ),
        ],
      ),
    );
  }
}
