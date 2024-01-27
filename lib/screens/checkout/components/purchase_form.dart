import 'package:Wishy/components/payment_button.dart';
import 'package:Wishy/components/payment_widget.dart';
import 'package:Wishy/components/top_rounded_container.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/CheckoutData.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/components/address_widget.dart';
import 'package:Wishy/screens/checkout/components/total_price.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/utils/generate_variant_description.dart';
import 'package:Wishy/utils/stripe_payment.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Address.dart' as Wishy;
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'dart:async';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uuid/uuid.dart';

class PurchaseForm extends StatefulWidget {
  final int variantId;
  final Product product;
  final int? recipientId;
  final double price;

  PurchaseForm({
    required this.variantId,
    required this.product,
    required this.price,
    this.recipientId,
  });

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  Wishy.Address? _selectedAddress;
  int? userId;
  String? name, phoneNumber;
  final _formKey = GlobalKey<FormState>();
  Follower? _defaultUser;
  CheckoutData? _checkout = null;
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);
  final double sectionMargin = 10;
  late Variant variant;
  final String _paymentSession = Uuid().v1();
  String? _paymentMethod = null;

  Future<void> onSubmit() async {
    if (_selectedAddress != null && _checkout != null)
      try {
        // await StripePaymentHandle().stripeMakePayment(_clientSecret!);
        // if (result != null && result["checkout_available"] == false) {
        //   AnalyticsService.trackEvent(analyticEvents["NEW_PURCHASE"]!,
        //       properties: {
        //         "Variant Id": widget.variantId,
        //         "Is Gift": false,
        //         "Recipient Id": _recipientId
        //       });

        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     content: Text(
        //         "Sorry, purchase feature is currently unavailable. We'll notify you when it's ready. Thank you!"),
        //   ));

        //   Navigator.pushNamed(
        //     context,
        //     HomeScreen.routeName,
        //   );
        //   return;
        // }

        // if (result != null && result["payment_url"] != null) {
        //   showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return Dialog.fullscreen(
        //         child: CheckoutWebView(checkoutUrl: result["payment_url"]),
        //       );
        //     },
        //   ).then((_) {
        //     AnalyticsService.trackEvent(analyticEvents["NEW_PURCHASE"]!,
        //         properties: {
        //           "Variant Id": widget.variantId,
        //           "Is Gift": false,
        //           "Recipient Id": _recipientId
        //         });

        //     Navigator.pushNamed(
        //       context,
        //       HomeScreen.routeName,
        //     );
        //   });
        //   ;
        // } else {
        //   throw Exception('Payment URL not available');
        // }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Unable to upload payment method. Please check your information and try again.'),
        ));
      }
  }

  Future<void> _fetchDeliveryTime() async {
    if (_selectedAddress == null) return;

    final addressId = _selectedAddress!.id;

    final temp = await graphQLQueryHandler("setCheckout", {
      "product_id": widget.product.id,
      "address_id": addressId,
      "variant_id": variant.id,
      "payment_id": GlobalManager().paymentId,
      "payment_session": _paymentSession + addressId.toString(),
      "price": variant.price,
      "quantity": 1,
      "cursor": GlobalManager().firstFeedCursor,
    });

    if (mounted && _selectedAddress?.id == addressId) {
      setState(() {
        _checkout = CheckoutData.fromJson(temp);
      });

      GlobalManager().setPaymentId(_checkout!.paymentId);
    }
  }

  void initState() {
    variant = widget.product.variants!.firstWhere(
        (element) => element.id == widget.variantId,
        orElse: () => widget.product.variants![0]);

    _defaultUser = Follower(
        name: GlobalManager().user?.name ?? "",
        phoneNumber: GlobalManager().user?.phoneNumber ?? "",
        id: GlobalManager().userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final variantDescription = generateVariantDescription(variant);

    return Center(
        child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _buildSection(
                Icons.person,
                firstColor,
                margin: 1,
                title: "Complete Purchase",
                AddressesWidget(
                  defaultUser: _defaultUser,
                  userId: GlobalManager().userId!,
                  onAddressSelected: (address) {
                    setState(() {
                      _selectedAddress = address;
                    });

                    _fetchDeliveryTime();
                  },
                ),
                child: _buildSection(
                    Icons.local_shipping,
                    secondColor,
                    _checkout == null
                        ? Text("Please provide shipping address")
                        : Column(children: [
                            Text(
                              _checkout?.deliveryTime ?? "",
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              _checkout?.deliveryDisplayPrice ?? "",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            )
                          ]),
                    child: _buildSection(
                        elementRightPadding: 0,
                        Icons.credit_card,
                        firstColor,
                        PaymentWidget(
                          clientSecret: _checkout?.clientSecret,
                          buyNow: _selectedAddress != null && _checkout != null,
                          totalPrice: _checkout?.totalPrice,
                          amount: _checkout?.payAmount,
                          shippingDetails: ShippingDetails(
                              name: _selectedAddress?.name,
                              address: Address(
                                  city: _selectedAddress?.city,
                                  state: _selectedAddress?.state,
                                  country: _selectedAddress?.countryCode,
                                  postalCode: _selectedAddress?.zipCode,
                                  line1: _selectedAddress != null
                                      ? _selectedAddress!.streetAddress +
                                          _selectedAddress!.streetNumber
                                      : null,
                                  line2: _selectedAddress?.apartment)),
                        ),
                        child: _buildSection(
                            Icons.receipt,
                            secondColor,
                            TotalPriceWidget(
                              enable:
                                  _selectedAddress != null && _checkout != null,
                              variant: variant,
                              productTitle: widget.product.title,
                              variantDescription: variantDescription,
                              deliveryPrice: _checkout?.deliveryPrice,
                              saleTax: _checkout?.saleTax,
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 12, right: 20, left: 20),
                              child: PaymentButton(
                                price: _checkout?.totalPrice ?? variant.price,
                                onSubmit: onSubmit,
                                enable:
                                    _checkout != null && _paymentMethod != null,
                              ),
                            )))),
              )
            ])));
  }

  _buildSection(IconData icon, Color color, Widget element,
      {double margin = 10,
      String? title,
      Widget? child,
      double elementRightPadding = 30}) {
    return TopRoundedContainer(
        margin: margin,
        padding: 10,
        color: color,
        child: Column(children: [
          if (title != null) ...[
            Text(title, style: headingStyle),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
          ],
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(20), child: Icon(icon, size: 30)),
                Container(
                    width: 280,
                    padding:
                        EdgeInsets.only(right: elementRightPadding, left: 5),
                    child: element),
              ]),
          if (child != null) child
        ]));
  }
}
