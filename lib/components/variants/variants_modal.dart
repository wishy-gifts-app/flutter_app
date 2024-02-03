import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';

void showVariantsModal(
    BuildContext context, Product product, int? recipientId, String situation,
    {String? cursor}) {
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
        return SingleChildScrollView(
            child: Column(
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
              product: product,
              recipientId: recipientId,
              situation: situation,
              cursor: cursor,
            )
          ],
        ));
      });
}
