import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentHandler {
  Future<void> stripeMakePayment(
      String client_secret, BuildContext context) async {
    try {
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              googlePay: const PaymentSheetGooglePay(
                merchantCountryCode: 'US',
                testEnv: true,
              ),
              paymentIntentClientSecret: client_secret,
              customFlow: true,
              style: ThemeMode.dark,
              merchantDisplayName: 'Wishy'));

      displayPaymentSheet(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<T?> paymentWrapper<T>(BuildContext context, Function handler) async {
    try {
      final T result = await handler();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successfully completed')),
      );

      return result;
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error to proceed: ${e.error.localizedMessage}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unforeseen error: ${e}')),
        );
      }
    }

    return null;
  }

  Future<PaymentSheetPaymentOption?> displayPaymentSheet(
      BuildContext context) async {
    return paymentWrapper<PaymentSheetPaymentOption>(
        context, () => Stripe.instance.presentPaymentSheet());
  }

  Future<PaymentIntent?> confirmCard(String clientSecret,
      ShippingDetails shippingDetails, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.confirmPayment(
              paymentIntentClientSecret: clientSecret,
              data: PaymentMethodParams.card(
                paymentMethodData:
                    PaymentMethodData(shippingDetails: shippingDetails),
              ),
            ));
  }

  Future<PlatformPayPaymentMethod?> createGooglePayment(String clientSecret,
      int amount, ShippingDetails shippingDetails, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.createPlatformPayPaymentMethod(
            params: PlatformPayPaymentMethodParams.googlePay(
                googlePayPaymentMethodParams: GooglePayPaymentMethodParams(
                  amount: amount,
                ),
                googlePayParams: GooglePayParams(
                    currencyCode: marketDetails["currency"]!,
                    merchantCountryCode:
                        shippingDetails.address.country ?? "US",
                    allowCreditCards: true,
                    testEnv: true,
                    merchantName: "Wishy"))));
  }

  Future<PaymentIntent?> createCashAppPayment(String clientSecret,
      ShippingDetails shippingDetails, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.confirmPayment(
              paymentIntentClientSecret: clientSecret,
              data: PaymentMethodParams.cashAppPay(
                paymentMethodData:
                    PaymentMethodData(shippingDetails: shippingDetails),
              ),
            ));
  }
}
