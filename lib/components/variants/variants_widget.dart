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

Variant? getSelectedVariant(
    List<Variant> productVariants, List<Attribute> selectedAttributes) {
  for (Variant variant in productVariants) {
    if (isAllAttributesExists(selectedAttributes, variant.attributes)) {
      return variant;
    }
  }

  return null;
}

Map<String, dynamic>? getAttributesMapById(
    int variantId, List<Variant> variants) {
  final variant = variants.firstWhere((item) => item.id == variantId);

  if (variant.attributes == null) return null;

  final Map<String, dynamic> variantMap = {};

  variant.attributes!.forEach((item) => variantMap[item.name] = item.value);

  return variantMap;
}

bool isAllAttributesExists(
    List<Attribute> newAttributes, List<Attribute>? variantAttributes) {
  if (variantAttributes == null) return false;

  return newAttributes.every((newAttribute) {
    return newAttribute.isExistIn(variantAttributes);
  });
}

// Map<String, List<Attribute>> getAvailableAttributesByName(
//     List<Attribute> attributes, List<Variant> variants) {
//   List<Map<String, Attribute>> variantAttributesMaps = variants.map((variant) {
//     return Map.fromIterable(variant.attributes ?? [],
//         key: (attr) => attr.name as String, value: (attr) => attr as Attribute);
//   }).toList();

//   Map<String, Set<Attribute>> availableAttributesByName = {};

//   for (var attribute in attributes) {
//     Set<Attribute> availableAttributes = {};

//     for (var variantAttributesMap in variantAttributesMaps) {
//       if (variantAttributesMap.containsKey(attribute.name)) {
//         availableAttributes.add(variantAttributesMap[attribute.name]!);
//       }
//     }

//     availableAttributesByName[attribute.name] = availableAttributes;
//   }

//   return availableAttributesByName
//       .map((key, value) => MapEntry(key, value.toList()));
// }

Map<String, List<Attribute>> getAvailableAttributesByName(
    List<Attribute> selectedAttributes, List<Variant> variants) {
  Map<String, List<Attribute>> availableAttributesByName = {};

  selectedAttributes.forEach((attribute) {
    availableAttributesByName[attribute.name] = [];
  });

  for (String attributeName in availableAttributesByName.keys) {
    Map<String, Attribute> uniqueAttributes = {};
    List<Attribute> otherSelectedAttributes = [];

    selectedAttributes.forEach((v) {
      if (v.name != attributeName) otherSelectedAttributes.add(v);
    });

    for (Variant variant in variants) {
      if (isAllAttributesExists(otherSelectedAttributes, variant.attributes)) {
        final attribute = variant.attributes!
            .firstWhere((element) => element.name == attributeName);
        uniqueAttributes[attribute.value] = attribute;
      }
    }

    availableAttributesByName[attributeName] =
        uniqueAttributes.values.map((v) => v).toList();
  }

  return availableAttributesByName;
}

class VariantsWidget extends StatefulWidget {
  final String situation, buttonText;
  final Product product;
  final int? variantId, recipientId;
  final String? productTitle, cursor;
  final bool withBuyButton;
  final Function(Variant? type)? onVariantChange;

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
  List<Attribute> currentAttributes = [];
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);
  Variant? selectedVariant;
  Map<String, List<Attribute>> availableVariantsByName = {};
  Map<String, dynamic>? chosenVariant;

  void _onVariantChange(Attribute newAttribute) {
    final oldVariant = selectedVariant;
    setState(() {
      currentAttributes.removeWhere((attr) => attr.name == newAttribute.name);
      currentAttributes.add(newAttribute);
    });

    setState(() {
      selectedVariant =
          getSelectedVariant(widget.product.variants!, currentAttributes);
    });

    if (widget.onVariantChange != null)
      widget.onVariantChange!(selectedVariant);

    _handleVariantSelection(currentAttributes, oldVariant);
  }

  void _handleVariantSelection(List<Attribute> values, Variant? v) {
    if (v != null &&
        availableVariantsByName.isNotEmpty &&
        isAllAttributesExists(values, v.attributes!)) return;

    setState(() {
      availableVariantsByName =
          getAvailableAttributesByName(values, widget.product.variants!);
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
    chosenVariant = widget.variantId != null
        ? getAttributesMapById(widget.variantId!, widget.product.variants!)
        : null;

    selectedVariant = widget.variantId != null
        ? widget.product.variants!
            .firstWhere((element) => element.id == widget.variantId!)
        : widget.product.variants![0];
    currentAttributes =
        selectedVariant!.attributes!.map((attribute) => attribute).toList();
    _handleVariantSelection(currentAttributes, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final variantsWithChildren =
        getVariantsDataWithChildren(widget.product.variants!);

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
              "${widget.buttonText} ${marketDetails["symbol"]}${(this.selectedVariant ?? widget.product.variants![0]).price}",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": widget.product.id,
            "Product Title": widget.productTitle,
            "Situation": widget.situation,
            "Variant Picked": true,
            "Variants Exist": true,
            "Delivery Availability": GlobalManager().isDeliveryAvailable
          },
          enable: selectedVariant != null,
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
                : null,
            availableVariantsByName[variantsWithChildren["type"]]),
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
