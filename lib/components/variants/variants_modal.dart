import 'package:Wishy/components/variants/variants_form.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';

void showVariantsModal(BuildContext context, int productId, String productTitle,
    List<Variant> variants, int? recipientId, String situation,
    {String? cursor}) {
  final variantsObjects = groupVariants(variants);
  List<dynamic> nonNullValue =
      variantsObjects.values.where((value) => value != null).toList();
  int totalLength = 1;
  variantsObjects.forEach((key, value) {
    if (value != null) {
      int lengthSum = value.fold<int>(
          0, (int sum, dynamic item) => sum + item.length as int);

      if (key == 'color') {
        totalLength += lengthSum;
      } else {
        totalLength += key.length + lengthSum;
      }
    }
  });
  final modalHeight = (totalLength * 0.005 + nonNullValue.length * 0.2 > 0.5)
      ? totalLength * 0.006 + nonNullValue.length * 0.176
      : 0.5;

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
            heightFactor: modalHeight,
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
                  cursor: cursor,
                )
              ],
            ));
      });
}
