import 'package:flutter/material.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../size_config.dart';

class HomeHeader extends StatelessWidget {
  final double? height;

  const HomeHeader({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Buying for yourself"), // Text 'Buy'
                IconButton(
                  icon: Icon(Icons.edit), // Edit icon
                  onPressed: () {
                    // Edit action
                  },
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.filter_list), // Filter icon
              onPressed: () {
                // Filter action
              },
            ),
          ],
        ),
      ),
    );
  }
}
