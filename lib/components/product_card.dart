import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    this.availableHeight,
    this.isFullScreen = false,
  }) : super(key: key);

  final Product product;
  final bool isFullScreen;
  final double? availableHeight;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        DetailsScreen.routeName,
        arguments: ProductDetailsArguments(product: product),
      ),
      child: Container(
        width: isFullScreen ? screenWidth : getProportionateScreenWidth(140),
        height: isFullScreen ? availableHeight : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Round corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image with rounded corners
            Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      product.images[0],
                      fit: BoxFit.contain,
                    ),
                  ),
                )),
            // Padding for Content
            Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(),
                  Text(
                    product.title,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
