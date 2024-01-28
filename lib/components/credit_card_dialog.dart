import 'package:Wishy/components/custom_dialog.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/payment_button.dart';
import 'package:Wishy/components/stripe_powered.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void showCreditCardDialog(BuildContext context, Function onSubmit, bool buyNow,
    {double? price}) async {
  CustomDialog().show(
    context,
    "Add your card details",
    CreditCardDialogContent(
      onSubmit: onSubmit,
      price: price,
      buyNow: buyNow,
    ),
  );
}

class CreditCardDialogContent extends StatefulWidget {
  final Function onSubmit;
  final bool buyNow;
  final double? price;

  CreditCardDialogContent({
    this.buyNow = false,
    this.price,
    required this.onSubmit,
  });

  @override
  _CreditCardDialogContentsState createState() =>
      _CreditCardDialogContentsState();
}

class _CreditCardDialogContentsState extends State<CreditCardDialogContent> {
  bool _saveCard = false;
  final _controller = CardFormEditController();

  @override
  void initState() {
    _controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(update);
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    await widget.onSubmit(_controller.details);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(right: 18, left: 18, bottom: 18, top: 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _saveCard,
                  onChanged: (bool? value) {
                    setState(() {
                      _saveCard = value!;
                    });
                  },
                ),
                Text(
                  "Save card for other purchases",
                  style: TextStyle(fontSize: 14),
                ),
                // ... add other elements if needed
              ],
            ),
            CardFormField(
              controller: _controller,
              autofocus: true,
              style: CardFormStyle(
                placeholderColor: kSecondaryColor,
                cursorColor: kPrimaryColor,
              ),
            ),
            StripePoweredWidget(),
            SizedBox(
              height: 5,
            ),
            if (widget.buyNow)
              PaymentButton(
                price: widget.price!,
                onSubmit: _onSubmit,
                enable: _controller.details.complete == true,
              ),
            if (!widget.buyNow)
              DefaultButton(
                text: "Add Card",
                press: _onSubmit,
                enable: _controller.details.complete == true,
              )
          ]),
    ));
  }
}
