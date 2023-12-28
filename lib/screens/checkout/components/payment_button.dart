import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/gestures.dart';

class PaymentButton extends StatelessWidget {
  final onSubmit;
  final bool enable;
  final bool loading;
  final double price;
  final Map<String, dynamic>? eventData;

  PaymentButton(
      {required this.price,
      required this.onSubmit,
      required this.loading,
      this.enable = true,
      this.eventData});

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
        DefaultButton(
          text: "Confirm Purchase",
          press: onSubmit,
          enable: enable,
          eventName: analyticEvents["PAY_PRESSED"],
          eventData: eventData,
        ),
      ],
    );
  }
}
