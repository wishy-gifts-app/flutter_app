import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/components/buy_as_gift_form.dart';
import 'package:Wishy/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/gestures.dart';

class PaymentButton extends StatelessWidget {
  final onSubmit;
  final bool enable;

  PaymentButton({required this.onSubmit, this.enable = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodySmall,
            children: <TextSpan>[
              TextSpan(
                text:
                    "By completing this purchase, you confirm that you agree with our ",
              ),
              TextSpan(
                text: "Purchase and Refund Terms",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        DefaultButton(text: "Go to payment", press: onSubmit, enable: enable),
      ],
    );
  }
}
