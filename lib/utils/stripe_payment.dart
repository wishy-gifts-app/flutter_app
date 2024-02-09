import 'package:Wishy/constants.dart';
import 'package:Wishy/models/UserPaymentMethod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentHandler {
  Future<T?> paymentWrapper<T>(BuildContext context, Function handler) async {
    final T? result = await stripeExceptionWrapper(context, handler);

    if (result != null)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successfully completed')),
      );

    return result;
  }

  Future<T?> stripeExceptionWrapper<T>(
      BuildContext context, Function handler) async {
    try {
      final T result = await handler();

      return result;
    } on Exception catch (e) {
      if (e is StripeException) {
        FirebaseCrashlytics.instance.recordError(
            Exception("Stripe error: " + (e.error.localizedMessage ?? "")),
            StackTrace.current);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('Error to proceed: ${e.error.localizedMessage}')),
        );
      } else {
        FirebaseCrashlytics.instance.recordError(
            Exception("Stripe error: " + (e.toString())), StackTrace.current);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('Unforeseen error: ${e}')),
        );
      }
    }

    return null;
  }

  Future<PaymentMethod?> createCard(BuildContext context) =>
      stripeExceptionWrapper(
          context,
          () => Stripe.instance.createPaymentMethod(
              params: PaymentMethodParams.card(
                paymentMethodData: PaymentMethodData(),
              ),
              options: PaymentMethodOptions(
                  setupFutureUsage: PaymentIntentsFutureUsage.OnSession)));

  Future<PaymentIntent?> confirmCard(String clientSecret,
      UserPaymentMethod cardDetail, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.confirmPayment(
              paymentIntentClientSecret: clientSecret,
              data: PaymentMethodParams.cardFromMethodId(
                paymentMethodData: PaymentMethodDataCardFromMethod(
                  paymentMethodId: cardDetail.paymentId!,
                ),
              ),
            ));
  }

  Future<PlatformPayPaymentMethod?> createGooglePayment(
      String clientSecret, int amount, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.createPlatformPayPaymentMethod(
            params: PlatformPayPaymentMethodParams.googlePay(
                googlePayPaymentMethodParams: GooglePayPaymentMethodParams(
                  amount: amount,
                ),
                googlePayParams: GooglePayParams(
                    currencyCode: marketDetails["currency"]!,
                    merchantCountryCode: "US",
                    allowCreditCards: true,
                    testEnv: true,
                    merchantName: "Wishy"))));
  }

  Future<PaymentIntent?> createCashAppPayment(
      String clientSecret, BuildContext context) async {
    return paymentWrapper(
        context,
        () => Stripe.instance.confirmPayment(
              paymentIntentClientSecret: clientSecret,
              data: PaymentMethodParams.cashAppPay(
                paymentMethodData: PaymentMethodData(),
              ),
            ));
  }
}
