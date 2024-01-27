import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/components/variants/variants_form.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/size_config.dart';
import '../../../components/top_rounded_container.dart';

Variant getSelectedVariant(
    List<Variant> productVariants, Map<String, dynamic> variantsObject) {
  for (Variant variant in productVariants) {
    bool matches = true;
    for (String key in variantsObject.keys) {
      if (variant.get(key) != variantsObject[key]) {
        matches = false;
        break;
      }
    }
    if (matches) {
      return variant;
    }
  }
  return productVariants[0];
}

Map<String, dynamic> getVariantsById(int variantId, List<Variant> variants) {
  final variant = variants.firstWhere((item) => item.id == variantId);
  final Map<String, dynamic> variantMap = {};

  if (variant.size != null) {
    variantMap["size"] = variant.size;
  }
  if (variant.color != null) {
    variantMap["color"] = variant.color;
  }
  if (variant.material != null) {
    variantMap["material"] = variant.material;
  }
  if (variant.style != null) {
    variantMap["style"] = variant.style;
  }

  return variantMap;
}

class VariantsWidget extends StatefulWidget {
  final String situation, buttonText;
  final Product product;
  final int? variantId, recipientId;
  final String? productTitle, cursor;
  final bool withBuyButton;
  final Function(String type, String value)? onVariantChange;

  const VariantsWidget({
    Key? key,
    required this.situation,
    required this.product,
    this.productTitle,
    this.onVariantChange,
    this.buttonText = "Buy Now",
    this.variantId,
    this.withBuyButton = true,
    this.recipientId,
    this.cursor = null,
  }) : super(key: key);

  @override
  _VariantsWidgetState createState() => _VariantsWidgetState();
}

class _VariantsWidgetState extends State<VariantsWidget> {
  Map<String, dynamic> variants = {};
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);
  late Variant selectedVariant;

  void _onVariantChange(String type, String value) {
    if (widget.onVariantChange != null) widget.onVariantChange!(type, value);

    setState(() {
      variants[type] = value;
    });

    setState(() {
      selectedVariant = getSelectedVariant(widget.product.variants!, variants);
    });
  }

  void _onBuyPressed(BuildContext context) async {
    if (!GlobalManager().isDeliveryAvailable!) {
      await DeliveryAvailabilityDialog.show(context);

      if (!GlobalManager().isDeliveryAvailable!) {
        return;
      }
    }

    Navigator.pushNamed(
      context,
      CheckoutScreen.routeName,
      arguments: {
        'variant': this.selectedVariant,
        'product': widget.product,
        'recipientId': widget.recipientId,
        'cursor': widget.cursor,
      },
    );
  }

  @override
  void initState() {
    selectedVariant = widget.product.variants![0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final variantsWithChildren =
        getVariantsDataWithChildren(widget.product.variants!);
    final Map<String, dynamic>? chosenVariant = widget.variantId != null
        ? getVariantsById(widget.variantId!, widget.product.variants!)
        : null;

    return (buildVariantsSectionWithButton(
        variantsWithChildren!, secondColor, context, chosenVariant));
  }

  TopRoundedContainer buildButton(Color color, BuildContext context) {
    return TopRoundedContainer(
      color: color,
      child: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.15,
          right: SizeConfig.screenWidth * 0.15,
          bottom: getProportionateScreenWidth(40),
          top: getProportionateScreenWidth(15),
        ),
        child: DefaultButton(
          text:
              "${widget.buttonText} ${marketDetails["symbol"]}${this.selectedVariant.price}",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": widget.product.id,
            "Product Title": widget.productTitle,
            "Situation": widget.situation,
            "Variant Picked": true,
            "Variants Exist": true,
            "Delivery Availability": GlobalManager().isDeliveryAvailable
          },
          press: () => _onBuyPressed(context),
        ),
      ),
    );
  }

  TopRoundedContainer buildVariantsSectionWithButton(
      Map<String, dynamic> variantsWithChildren,
      Color color,
      BuildContext context,
      Map<String, dynamic>? chosenVariantMap) {
    Color nextColor = color == firstColor ? secondColor : firstColor;

    return TopRoundedContainer(
      color: color,
      child: Column(children: [
        getVariantWidget(
            variantsWithChildren["type"],
            variantsWithChildren["values"],
            _onVariantChange,
            chosenVariantMap != null
                ? chosenVariantMap[variantsWithChildren["type"]]
                : null),
        if (variantsWithChildren["child"] != null)
          buildVariantsSectionWithButton(variantsWithChildren["child"],
              nextColor, context, chosenVariantMap)
        else
          widget.withBuyButton
              ? buildButton(nextColor, context)
              : SizedBox(
                  height: getProportionateScreenHeight(10),
                )
      ]),
    );
  }
}
