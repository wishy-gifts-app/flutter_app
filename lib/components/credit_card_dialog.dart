import 'package:Wishy/components/custom_dialog.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/payment_button.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<CardFieldInputDetails?> showCreditCardDialog(
    BuildContext context, Function onSubmit, bool buyNow,
    {double? price}) async {
  CardFieldInputDetails? _card;

  await CustomDialog().show(
    context,
    "Add your card details",
    CreditCardDialogContent(
      onSubmit: onSubmit,
      price: price,
      buyNow: buyNow,
    ),
  );
  return _card;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(right: 18, left: 18, bottom: 18, top: 18),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CardFormField(
              controller: _controller,
              autofocus: true,
              style: CardFormStyle(
                  placeholderColor: kSecondaryColor,
                  cursorColor: kPrimaryColor),
            ),
            CheckboxListTile(
              title: Text(
                "Save card for other purchases",
                style: TextStyle(fontSize: 14),
              ),
              value: _saveCard,
              onChanged: (bool? value) {
                setState(() {
                  _saveCard = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (widget.buyNow)
              PaymentButton(
                price: widget.price!,
                onSubmit: widget.onSubmit,
                enable: _controller.details.complete == true,
              ),
            if (!widget.buyNow)
              DefaultButton(
                text: "Add Card",
                press: widget.onSubmit,
                enable: _controller.details.complete == true,
              )
          ]),
    ));
  }
}
