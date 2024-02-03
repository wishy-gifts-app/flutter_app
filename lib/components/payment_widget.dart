import 'package:Wishy/components/button_cards.dart';
import 'package:Wishy/components/credit_card.dart';
import 'package:Wishy/components/credit_card_dialog.dart';
import 'package:Wishy/components/stripe_powered.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/UserPaymentMethod.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/stripe_payment.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Widget getPayButtonSuffixByType(
    PaymentMethods type, UserPaymentMethod? cardDetails) {
  Widget? customWidget;
  switch (type) {
    case PaymentMethods.google_pay:
      customWidget = SvgPicture.asset(
        'assets/icons/google-icon.svg',
        height: 25,
      );
      break;
    case PaymentMethods.cash_app:
      customWidget = SvgPicture.asset(
        'assets/icons/cash-app-badge.svg',
        height: 25,
      );
      break;
    case PaymentMethods.card:
      customWidget = CreditCardWidget(
        digits: cardDetails!.lastDigits!,
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

dynamic payByType(PaymentMethods type, BuildContext context, int index,
    UserPaymentMethod cardDetails, String? clientSecret, int? amount) async {
  final stripePaymentHandler = StripePaymentHandler();
  Function payMethod;
  switch (type) {
    case PaymentMethods.google_pay:
      payMethod = () => stripePaymentHandler.createGooglePayment(
          clientSecret!, amount!, context);
      break;
    case PaymentMethods.cash_app:
      payMethod = () =>
          stripePaymentHandler.createCashAppPayment(clientSecret!, context);
      break;
    case PaymentMethods.card:
      payMethod = () => StripePaymentHandler()
          .confirmCard(clientSecret!, cardDetails, context);
      break;
    default:
      payMethod = () => print("Method for type: $type doesn't exists");
  }

  final result = await payMethod();
  GlobalManager().setPaymentsAfterCheckout(index);
  //TODO After payment iclude set correct selected payment

  return result;
}

class PaymentWidget extends StatelessWidget {
  final String? clientSecret;
  final double? totalPrice;
  final int? amount;
  final int selectedIndex;
  final bool buyNow;
  final Stripe.ShippingDetails? shippingDetails;
  final Function onPaymentSelected;

  PaymentWidget(
      {required this.clientSecret,
      this.totalPrice,
      this.amount,
      this.shippingDetails,
      required this.selectedIndex,
      required this.onPaymentSelected,
      this.buyNow = false});

  final stripePaymentHandler = StripePaymentHandler();

  Future<dynamic> _onSubmitCard(BuildContext context,
      Stripe.CardFieldInputDetails card, bool? saveCard) async {
    final result = await stripePaymentHandler.createCard(context);
    if (result != null) {
      UserPaymentMethod paymentCard;
      if (saveCard == true) {
        try {
          final temp = await graphQLQueryHandler(
              "saveUserPaymentCard", {"payment_id": result.id});

          paymentCard = new UserPaymentMethod.fromJson(temp);
          GlobalManager().insertPaymentCard(paymentCard);
        } catch (error) {
          print(error);
          FirebaseCrashlytics.instance.recordError(
              Exception("Save Card error: " + (error.toString())),
              StackTrace.current);

          paymentCard = new UserPaymentMethod(
              id: null,
              paymentId: result.id,
              lastDigits: result.card.last4!,
              lastUpdatedAt: new DateTime.now(),
              userId: GlobalManager().userId!,
              method: PaymentMethods.card,
              saved: false);
          GlobalManager().insertPaymentCard(paymentCard);
        }
      } else {
        paymentCard = new UserPaymentMethod(
            id: null,
            paymentId: result.id,
            lastDigits: result.card.last4!,
            lastUpdatedAt: new DateTime.now(),
            userId: GlobalManager().userId!,
            method: PaymentMethods.card,
            saved: false);
        GlobalManager().insertPaymentCard(paymentCard);
      }

      if (buyNow) {
        final handler = payByType(
            PaymentMethods.card, context, 0, paymentCard, clientSecret, amount);
        if (handler != null) await handler!();
      } else {
        final handler = () => payByType(
            PaymentMethods.card, context, 0, paymentCard, clientSecret, amount);
        onPaymentSelected(handler,
            getPayButtonSuffixByType(PaymentMethods.card, paymentCard), 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalManger = Provider.of<GlobalManager>(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Choose your preferred payment method",
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 12),
      ),
      Container(
          height: 85,
          padding: EdgeInsets.only(top: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddCard(context),
                // _buildPaypalCard(),
                // if (Platform.isIOS) _buildApplePayCard(),
                ...(globalManger.user?.paymentMethods ?? [])
                    .asMap()
                    .entries
                    .map((entry) {
                  return getPayCardByType(
                      entry.value.method, context, entry.key, entry.value);
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
            decoration: index == selectedIndex
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

  Widget _buildGooglePayCard(
      BuildContext context, int index, UserPaymentMethod details) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/google-pay-logo.svg',
          height: 20,
        ),
        () => onPaymentSelected(
            () => payByType(PaymentMethods.google_pay, context, index, details,
                this.clientSecret, this.amount),
            getPayButtonSuffixByType(PaymentMethods.google_pay, details),
            index),
        index);
  }

  Widget _buildCreditCard(
      BuildContext context, int index, UserPaymentMethod details) {
    return _buildCard(
        CreditCardWidget(
          digits: details.lastDigits!,
          isBlack: true,
          size: CreditCardSize.small,
        ),
        () => onPaymentSelected(
            () => payByType(PaymentMethods.card, context, index, details,
                this.clientSecret, this.amount),
            getPayButtonSuffixByType(PaymentMethods.card, details),
            index),
        index);
  }

  Widget _buildCashAppCard(
      BuildContext context, int index, UserPaymentMethod details) {
    return _buildCard(
        SvgPicture.asset(
          'assets/icons/cash-app-pay.svg',
          height: 45,
        ),
        () => onPaymentSelected(
            () => payByType(PaymentMethods.cash_app, context, index, details,
                this.clientSecret, this.amount),
            getPayButtonSuffixByType(PaymentMethods.cash_app, details),
            index),
        index);
  }

  Widget _buildAddCard(BuildContext context) {
    return _buildCard(Icon(Icons.add_card, size: 40), () async {
      showCreditCardDialog(
        context,
        (card, saveCard) => _onSubmitCard(context, card, saveCard),
        buyNow,
        price: totalPrice,
      );
    }, null);
  }

  Widget getPayCardByType(PaymentMethods type, BuildContext context, int index,
      UserPaymentMethod details) {
    switch (type) {
      case PaymentMethods.google_pay:
        return _buildGooglePayCard(context, index, details);
      case PaymentMethods.cash_app:
        return _buildCashAppCard(context, index, details);
      case PaymentMethods.card:
        return _buildCreditCard(context, index, details);

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
