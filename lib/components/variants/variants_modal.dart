import 'package:Wishy/components/variants/variants_form.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';

void showVariantsModal(BuildContext context, int productId, String productTitle,
    List<Variant> variants, int? recipientId, String situation) {
  final variantsObjects = groupVariants(variants);
  int nonNullValueCount =
      variantsObjects.values.where((value) => value != null).length;

  showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
            heightFactor: nonNullValueCount > 2 ? 0.72 : 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.only(top: getProportionateScreenWidth(20)),
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
                  recipientId: recipientId,
                  situation: situation,
                )
              ],
            ));
      });
}
