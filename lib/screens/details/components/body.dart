import 'package:flutter/material.dart';
import 'package:shop_app/components/additional_details_dialog.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/components/variants_form.dart';
import 'package:shop_app/size_config.dart';

import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;

  Body({Key? key, required this.product}) : super(key: key);
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);

  @override
  Widget build(BuildContext context) {
    final variantsWithChildren = getVariantsDataWithChildren(product.variants);

    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                pressOnSeeMore: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AdditionalDetailsDialog(
                        description: product.description,
                      );
                    },
                  );
                },
              ),
              if (variantsWithChildren != null)
                buildVariantsSectionWithButton(
                    variantsWithChildren, secondColor)
              else
                buildButton(secondColor)
            ],
          ),
        ),
      ],
    );
  }

  TopRoundedContainer buildButton(Color color) {
    return TopRoundedContainer(
      color: color,
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.15,
          right: SizeConfig.screenWidth * 0.15,
          bottom: getProportionateScreenWidth(40),
          top: getProportionateScreenWidth(15),
        ),
        child: DefaultButton(
          text: "Add To Cart",
          press: () {},
        ),
      ),
    );
  }

  TopRoundedContainer buildVariantsSectionWithButton(
      Map<String, dynamic> variantsWithChildren, Color color) {
    Color nextColor = color == firstColor ? secondColor : firstColor;
    return TopRoundedContainer(
      color: color,
      child: Column(children: [
        getVariantWidget(
            variantsWithChildren["type"], variantsWithChildren["values"]),
        if (variantsWithChildren["child"] != null)
          buildVariantsSectionWithButton(
              variantsWithChildren["child"], nextColor)
        else
          buildButton(nextColor)
      ]),
    );
  }
}
