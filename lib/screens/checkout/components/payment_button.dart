import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/checkout/components/buy_as_gift_form.dart';
import 'package:shop_app/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:shop_app/size_config.dart';

class PaymentButton extends StatelessWidget {
  final onSubmit;

  PaymentButton({required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "By continuing your confirm that you agree \nwith our Term and Condition",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        DefaultButton(
          text: "Go to payment",
          press: onSubmit,
        ),
      ],
    );
  }
}
