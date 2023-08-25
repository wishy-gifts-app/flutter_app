import 'package:shop_app/constants.dart';

import 'likes_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'likes_product.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  final double headerHeight = 60.0;
  final likedTab = new LikesProducts(
    isLike: true,
  );
  final unlikedTab = new LikesProducts(
    isLike: false,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          LikesHeader(height: headerHeight),
          TabBar(
            labelColor: Colors.black,
            indicatorColor: kPrimaryColor,
            tabs: [
              Tab(text: "Liked"),
              Tab(text: "Unliked"),
            ],
          ),
          Expanded(child: TabBarView(children: [likedTab, unlikedTab])),
        ],
      ),
    );
  }
}
