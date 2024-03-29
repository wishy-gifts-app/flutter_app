import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/refound_terms.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/gestures.dart';

class PaymentButton extends StatelessWidget {
  final onSubmit;
  final bool enable;
  final double price;
  final Map<String, dynamic>? eventData;
  final Widget? element;

  PaymentButton(
      {required this.price,
      required this.onSubmit,
      this.element,
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
                text: "See our full ",
              ),
              TextSpan(
                text: "Return Policy",
                style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog.fullscreen(child: RefoundTermsWebView());
                      },
                    );
                  },
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        DefaultButton(
          text: "Pay ${marketDetails["symbol"]}${price}",
          press: onSubmit,
          enable: enable,
          eventName: analyticEvents["PAY_PRESSED"],
          eventData: eventData,
          element: element,
        ),
      ],
    );
  }
}
