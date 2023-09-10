import 'package:flutter/material.dart';
import 'package:shop_app/components/variants/variants_widget.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';

void showVariantsModal(BuildContext context, Product product) {
  showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                child: Text(
                  'Select Your Preferred Variant',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                  ),
                )),
            VariantsWidget(
                productId: product.id,
                productTitle: product.title,
                productVariants: product.variants)
          ],
        );
      });
}