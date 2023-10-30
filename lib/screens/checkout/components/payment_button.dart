import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/components/buy_as_gift_form.dart';
import 'package:Wishy/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:Wishy/size_config.dart';

class PaymentButton extends StatelessWidget {
  final onSubmit;
  final bool enable;

  PaymentButton({required this.onSubmit, this.enable = true});

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
        DefaultButton(text: "Go to payment", press: onSubmit, enable: enable),
      ],
    );
  }
}
