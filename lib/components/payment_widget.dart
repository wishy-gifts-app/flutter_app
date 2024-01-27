import 'package:Wishy/components/button_cards.dart';
import 'package:Wishy/components/credit_card_dialog.dart';
import 'package:Wishy/utils/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

class PaymentWidget extends StatelessWidget {
  final String? clientSecret;
  final double? totalPrice;
  final int? amount;
  final bool buyNow;
  final Stripe.ShippingDetails? shippingDetails;

  PaymentWidget(
      {required this.clientSecret,
      this.totalPrice,
      this.amount,
      this.shippingDetails,
      this.buyNow = false});

  dynamic _onSubmitCard(BuildContext context) async {
    if (buyNow) {
      final result = await StripePaymentHandler()
          .confirmCard(clientSecret!, shippingDetails!, context);

      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Select your preferred payment method",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 12),
      ),
      Container(
          height: 100,
          padding: EdgeInsets.only(top: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddCard(context),
                // _buildPaypalCard(),
                // if (Platform.isIOS) _buildApplePayCard(),
                if (Platform.isAndroid) _buildGooglePayCard(context),
                _buildCashAppCard(context),
                ...[].map((method) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: Center(
                        child: Text(method),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          )),
    ]);
  }

  Widget _buildCard(
    Widget widget,
    void Function()? onTap,
  ) {
    return ButtonCards(
        onTap: onTap,
        child: Container(
            width: 90,
            child: Card(
                child: Center(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: widget,
              ),
            ))));
  }

  Widget _buildGooglePayCard(BuildContext context) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/google-pay-logo.svg',
          height: 20,
        ),
        () => buyNow
            ? StripePaymentHandler().createGooglePayment(
                clientSecret!, amount!, shippingDetails!, context)
            : null);
  }

  Widget _buildCashAppCard(BuildContext context) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/cash-app-pay.svg',
          height: 45,
        ),
        () => buyNow
            ? StripePaymentHandler()
                .createCashAppPayment(clientSecret!, shippingDetails!, context)
            : null);
  }

  Widget _buildAddCard(BuildContext context) {
    return _buildCard(
      Icon(Icons.add_card, size: 40),
      () => showCreditCardDialog(context, () => _onSubmitCard(context), buyNow,
          price: totalPrice),
    );
  }

  // Widget _buildApplePayCard() {
  //   return _buildCard(
  //       SvgPicture.asset(
  //         'assets/icons/apple-pay.svg',
  //         height: 50,
  //       ),
  //       null);
  // }

  // Widget _buildPaypalCard() {
  //   return _buildCard(
  //       SvgPicture.asset(
  //         'assets/icons/paypal.svg',
  //         height: 70,
  //       ),
  //       null);
  // }
}
