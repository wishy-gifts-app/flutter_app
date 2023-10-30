import 'package:flutter/material.dart';

import '../../models/Product.dart';
import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(rating: 5),
      ),
      body: Body(
        product: args.product,
        buttonText: args.buttonText,
        variantId: args.variantId,
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  final int? variantId;
  final String buttonText;

  ProductDetailsArguments(
      {required this.product, this.buttonText = "Buy Now", this.variantId});
}
