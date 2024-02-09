import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/variants/variants_modal.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:Wishy/utils/is_variants_exists.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../components/top_rounded_container.dart';

void navigateToCheckout(BuildContext context, Object arguments) async {
  Navigator.pushNamed(
    context,
    CheckoutScreen.routeName,
    arguments: arguments,
  );
}

Future<bool> isDeliveryAvailable(BuildContext context) async {
  await DeliveryAvailabilityDialog.show(context);

  if (GlobalManager().isDeliveryAvailable != true) {
    return false;
  }

  return true;
}

class BuyNowWidget extends StatefulWidget {
  final String situation;
  final GlobalKey? buttonKey;
  final Color startColor;
  final Product product;
  final int? recipientId;
  final Variant? defaultVariant;
  final int? chosenVariantId;
  final double firstMargin;
  final String? cursor;
  final Function(Variant? type)? onVariantChange;

  const BuyNowWidget({
    Key? key,
    required this.situation,
    required this.product,
    this.chosenVariantId,
    this.buttonKey,
    this.startColor = const Color(0xFFF6F7F9),
    this.onVariantChange,
    this.defaultVariant,
    this.recipientId,
    this.firstMargin = 20,
    this.cursor = null,
  }) : super(key: key);

  @override
  _BuyNowWidgetState createState() => _BuyNowWidgetState();
}

class _BuyNowWidgetState extends State<BuyNowWidget> {
  List<Attribute> currentAttributes = [];
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);
  Variant? selectedVariant;
  Map<String, List<Attribute>> availableVariantsByName = {};
  Map<String, dynamic>? chosenVariant;

  void _onVariantChange(Variant? newVariant) {
    setState(() {
      selectedVariant = newVariant;
    });

    if (widget.onVariantChange != null) widget.onVariantChange!(newVariant);
  }

  void _onSubmit(BuildContext context) async {
    if (await isDeliveryAvailable(context)) {
      navigateToCheckout(
        context,
        {
          'variant': this.selectedVariant,
          'product': widget.product,
          'recipientId': widget.recipientId,
          'cursor': widget.cursor,
        },
      );
    }
  }

  @override
  void initState() {
    selectedVariant = widget.product.variants![0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product.variants == null)
      return buildOutOfStock(secondColor);
    else if (isVariantsExists(widget.product.variants))
      return VariantsWidget(
        title: 'Select Your Preferred Variant',
        startColor: widget.startColor,
        firstMargin: widget.firstMargin,
        situation: widget.situation,
        chosenVariantId: widget.chosenVariantId,
        product: widget.product,
        defaultVariant: widget.defaultVariant ?? widget.product.variants![0],
        recipientId: widget.recipientId,
        cursor: widget.cursor,
        onVariantChange: _onVariantChange,
        buyButton: (color, context) => buildButton(color, context),
      );

    return buildButton(secondColor, context);
  }

  TopRoundedContainer buildOutOfStock(Color color) {
    return TopRoundedContainer(
      color: color,
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.15,
          right: SizeConfig.screenWidth * 0.15,
          bottom: getProportionateScreenWidth(40),
          top: getProportionateScreenWidth(15),
        ),
        child: Text("Out of stock",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 25)),
      ),
    );
  }

  TopRoundedContainer buildButton(Color color, BuildContext context) {
    return TopRoundedContainer(
      color: color,
      child: Padding(
        padding: EdgeInsets.only(
          left: 35,
          right: 35,
          bottom: getProportionateScreenWidth(40),
          top: getProportionateScreenWidth(15),
        ),
        child: DefaultButton(
          element: (this.selectedVariant ?? widget.product.variants![0])
                      .originalPrice !=
                  null
              ? Text(
                  "${(this.selectedVariant ?? widget.product.variants![0]).originalPrice}",
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: kPrimaryLightColor,
                      color: kPrimaryLightColor,
                      decorationThickness: 2),
                )
              : null,
          key: widget.buttonKey,
          text:
              "Buy Now ${marketDetails["symbol"]}${(this.selectedVariant ?? widget.product.variants![0]).price}",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": widget.product.id,
            "Product Title": widget.product.title,
            "Situation": widget.situation,
            "Variant Picked": true,
            "Variants Exist": true,
            "Delivery Availability": GlobalManager().isDeliveryAvailable
          },
          enable: selectedVariant != null,
          press: () => _onSubmit(context),
        ),
      ),
    );
  }
}

class BuyNowIcon extends StatelessWidget {
  final String situation;
  final Product product;
  final int? recipientId;
  final Variant? defaultVariant;
  final int? chosenVariantId;
  final double height;
  final double elevation;
  final String? cursor;
  final Function(Variant? type)? onVariantChange;

  const BuyNowIcon({
    Key? key,
    required this.situation,
    required this.product,
    this.chosenVariantId,
    this.onVariantChange,
    this.defaultVariant,
    this.recipientId,
    this.height = 50,
    this.elevation = 1.5,
    this.cursor = null,
  }) : super(key: key);

  void _onCheckoutPressed(BuildContext context) async {
    if (await isDeliveryAvailable(context)) {
      AnalyticsService.trackEvent(analyticEvents["CHECKOUT_PRESSED"]!,
          properties: {
            "Product Id": product.id,
            "Situation": situation,
            "Variants Exist": isVariantsExists(product.variants),
            "Variant Picked": false,
            "Delivery Availability": GlobalManager().isDeliveryAvailable
          });

      if (isVariantsExists(product.variants)) {
        showVariantsModal(context, product, recipientId, situation,
            cursor: cursor);
      } else {
        navigateToCheckout(context, {
          "recipientId": recipientId,
          'variant': product.variants![0],
          'product': product,
          "cursor": cursor
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: elevation,
        shadowColor: Colors.black,
        shape: CircleBorder(),
        child: ElevatedButton(
            onPressed: () {
              _onCheckoutPressed(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: CircleBorder(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/icons/buy_now.svg",
                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                height: height,
              ),
            )));
  }
}
