import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';

void showVariantsModal(
  BuildContext context,
  int productId,
  String productTitle,
  List<Variant> variants,
  int? recipientId,
) {
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
                productId: productId,
                productTitle: productTitle,
                productVariants: variants,
                recipientId: recipientId)
          ],
        );
      });
}
