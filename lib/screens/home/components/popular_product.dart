import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

import '../../../size_config.dart';
import 'package:shop_app/components/swipeable_products.dart'; // Import the widget

class PopularProducts extends StatelessWidget {
  final double height;

  const PopularProducts({Key? key, this.height = 150.0})
      : super(key: key); // Default value set to 150

  void _onSwipeRight(String id) {
    // Implement your logic here
  }

  void _onSwipeLeft(String id) {
    // Implement your logic here
  }

  void _onSwipeUp(String id) {
    // Implement your logic here
  }

  @override
  Widget build(BuildContext context) {
    // Filter out the popular products.
    List<Product> popularProducts =
        demoProducts.where((product) => product.isPopular).toList();

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Container(
        height: SizeConfig.screenHeight - height,
        child: SwipeableCardWidget(
          products: popularProducts,
          onSwipeRight: _onSwipeRight,
          onSwipeLeft: _onSwipeLeft,
          onSwipeUp: _onSwipeUp,
        ),
      ),
    );
  }
}
