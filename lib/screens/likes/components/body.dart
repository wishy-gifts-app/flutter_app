import 'package:shop_app/constants.dart';

import 'likes_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'likes_product.dart';

class Body extends StatelessWidget {
  final double headerHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
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
