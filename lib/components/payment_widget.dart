import 'package:Wishy/components/button_cards.dart';
import 'package:Wishy/components/credit_card.dart';
import 'package:Wishy/components/credit_card_dialog.dart';
import 'package:Wishy/components/stripe_powered.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/utils/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:flutter_svg/flutter_svg.dart';

enum PaymentTypes {
  card,
  google_pay,
  cash_app,
}

Widget getPayButtonSuffixByType(PaymentTypes type,
    {Stripe.PaymentMethod? cardDetails}) {
  Widget? customWidget;
  switch (type) {
    case PaymentTypes.google_pay:
      customWidget = SvgPicture.asset(
        'assets/icons/google-icon.svg',
        height: 25,
      );
      break;
    case PaymentTypes.cash_app:
      customWidget = SvgPicture.asset(
        'assets/icons/cash-app-badge.svg',
        height: 25,
      );
      break;
    case PaymentTypes.card:
      customWidget = CreditCardWidget(
        digits: cardDetails!.card.last4!,
        size: CreditCardSize.small,
      );
      break;

    default:
      return SizedBox.shrink();
  }

  return Row(children: [
    Text(
      "with",
      style: defaultButtonTextStyle,
    ),
    SizedBox(
      width: 8,
    ),
    customWidget
  ]);
}

class PaymentWidget extends StatefulWidget {
  final String? clientSecret;
  final double? totalPrice;
  final int? amount;
  final bool buyNow;
  final Stripe.ShippingDetails? shippingDetails;
  final Function onPaymentSelected;

  PaymentWidget(
      {required this.clientSecret,
      this.totalPrice,
      this.amount,
      this.shippingDetails,
      required this.onPaymentSelected,
      this.buyNow = false});

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  int? _selectedPayment = null;
  final stripePaymentHandler = StripePaymentHandler();
  List<List<dynamic>> _paymentMethod = [
    [PaymentTypes.google_pay],
    [PaymentTypes.cash_app]
  ];

  Future<dynamic> _onSubmitCard(
      BuildContext context, Stripe.CardFieldInputDetails card) async {
    final result = await stripePaymentHandler.createCard(context);
    if (result != null) {
      setState(() {
        _paymentMethod.insert(0, [PaymentTypes.card, result]);
        _selectedPayment = 0;
      });
      widget.onPaymentSelected(
          () => stripePaymentHandler.confirmCard(widget.clientSecret!,
              _paymentMethod[0][1], widget.shippingDetails!, context),
          getPayButtonSuffixByType(PaymentTypes.card,
              cardDetails: _paymentMethod[0][1]));
    }
    if (widget.buyNow) {
      // final result = await StripePaymentHandler()
      //     .confirmCard(widget.clientSecret!, widget.shippingDetails!, context);

      // return result;
    }
  }

  void Function() _walletWrapper(
          Function payMethod, int index, PaymentTypes type) =>
      () {
        setState(() {
          _selectedPayment = index;
        });

        widget.onPaymentSelected(payMethod, getPayButtonSuffixByType(type));

        if (widget.buyNow) {
          payMethod();
        }
      };

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Choose your preferred payment method",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 12),
      ),
      Container(
          height: 90,
          padding: EdgeInsets.only(top: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddCard(context),
                // _buildPaypalCard(),
                // if (Platform.isIOS) _buildApplePayCard(),
                ..._paymentMethod.asMap().entries.map((entry) {
                  return getPayCardByType(
                      entry.value[0] as PaymentTypes, context, entry.key,
                      cardDetails: entry.value.length > 1
                          ? (entry.value[1] as Stripe.PaymentMethod)
                          : null);
                }).toList()
              ],
            ),
          )),
      SizedBox(
        height: 5,
      ),
      StripePoweredWidget()
    ]);
  }

  Widget _buildCard(Widget element, void Function()? onTap, int? index) {
    return ButtonCards(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.only(top: 4, right: 8, bottom: 4),
            decoration: _selectedPayment != null && index == _selectedPayment
                ? BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(13))
                : null,
            width: 85,
            child: Card(
                margin: EdgeInsets.zero,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: element,
                  ),
                ))));
  }

  Widget _buildGooglePayCard(BuildContext context, int index) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/google-pay-logo.svg',
          height: 20,
        ),
        _walletWrapper(
            () => stripePaymentHandler.createGooglePayment(widget.clientSecret!,
                widget.amount!, widget.shippingDetails!, context),
            index,
            PaymentTypes.google_pay),
        index);
  }

  Widget _buildCreditCard(
      BuildContext context, int index, Stripe.PaymentMethod cardDetails) {
    return _buildCard(
        CreditCardWidget(
          digits: cardDetails.card.last4!,
          isBlack: true,
          size: CreditCardSize.small,
        ), () {
      setState(() {
        _selectedPayment = index;
      });
      widget.onPaymentSelected(() {
        stripePaymentHandler.confirmCard(widget.clientSecret!, cardDetails,
            widget.shippingDetails!, context);
      }, getPayButtonSuffixByType(PaymentTypes.card, cardDetails: cardDetails));
    }, index);
  }

  Widget _buildCashAppCard(BuildContext context, int index) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/cash-app-pay.svg',
          height: 45,
        ),
        _walletWrapper(
            () => stripePaymentHandler.createCashAppPayment(
                widget.clientSecret!, widget.shippingDetails!, context),
            index,
            PaymentTypes.cash_app),
        index);
  }

  Widget _buildAddCard(BuildContext context) {
    return _buildCard(Icon(Icons.add_card, size: 40), () async {
      setState(() {
        _selectedPayment = null;
      });
      widget.onPaymentSelected(null, null);
      showCreditCardDialog(
        context,
        (card) => _onSubmitCard(context, card),
        widget.buyNow,
        price: widget.totalPrice,
      );
    }, null);
  }

  Widget getPayCardByType(PaymentTypes type, BuildContext context, int index,
      {Stripe.PaymentMethod? cardDetails}) {
    switch (type) {
      case PaymentTypes.google_pay:
        return _buildGooglePayCard(context, index);
      case PaymentTypes.cash_app:
        return _buildCashAppCard(context, index);
      case PaymentTypes.card:
        return _buildCreditCard(context, index, cardDetails!);

      default:
        return SizedBox.shrink();
    }
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
