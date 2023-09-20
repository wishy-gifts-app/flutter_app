import 'package:Wishy/constants.dart';

import 'likes_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'likes_product.dart';

class Body extends StatelessWidget {
  final double headerHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          LikesHeader(height: headerHeight),
          Expanded(
              child: LikesProducts(
            isLike: true,
          )),
        ],
      ),
    );
  }
}
