import 'package:Wishy/components/product_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/components/variants/variants_form.dart';
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
  final int? recipientId;
  final Variant defaultVariant;
  final String? cursor, title;
  final Widget Function(Color, BuildContext)? buyButton;
  final Function(Variant? type)? onVariantChange;
  final int? chosenVariantId;
  final double firstMargin;
  final Color startColor;

  const VariantsWidget({
    Key? key,
    required this.situation,
    required this.product,
    this.onVariantChange,
    this.firstMargin = 20,
    this.startColor = const Color(0xFFF6F7F9),
    this.buttonText = "Buy Now",
    required this.defaultVariant,
    this.chosenVariantId,
    this.recipientId,
    this.buyButton,
    this.title,
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

  @override
  void initState() {
    selectedVariant = widget.defaultVariant;
    chosenVariant = widget.chosenVariantId != null
        ? getAttributesMapById(
            widget.chosenVariantId!, widget.product.variants!)
        : null;
    currentAttributes = widget.defaultVariant.attributes!
        .map((attribute) => attribute)
        .toList();
    _handleVariantSelection(currentAttributes, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final variantsWithChildren =
        getVariantsDataWithChildren(widget.product.variants!);

    return Stack(children: [
      widget.title == null
          ? buildVariantsSectionWithButton(
              variantsWithChildren!, widget.startColor, context, chosenVariant,
              isFirst: true, startMargin: widget.firstMargin)
          : _buildVariantsWithTitle(
              variantsWithChildren!, widget.startColor, context)
    ]);
  }

  TopRoundedContainer _buildVariantsWithTitle(
    Map<String, dynamic> variantsWithChildren,
    Color color,
    BuildContext context,
  ) {
    return TopRoundedContainer(
        margin: widget.firstMargin,
        padding: 6,
        color: color,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ProductImageWidget(product: widget.product, variant: selectedVariant),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.title!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          buildVariantsSectionWithButton(
              variantsWithChildren, color, context, chosenVariant,
              isFirst: true, startMargin: 10),
        ]));
  }

  TopRoundedContainer buildVariantsSectionWithButton(
      Map<String, dynamic> variantsWithChildren,
      Color color,
      BuildContext context,
      Map<String, dynamic>? chosenVariantMap,
      {bool isFirst = false,
      double startMargin = 20}) {
    Color nextColor = color == firstColor ? secondColor : firstColor;

    return TopRoundedContainer(
        margin: isFirst ? startMargin : 20,
        color: color,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
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
            widget.buyButton != null
                ? widget.buyButton!(nextColor, context)
                : SizedBox(
                    height: getProportionateScreenHeight(10),
                  )
        ]));
  }
}
