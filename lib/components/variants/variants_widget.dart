import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/components/variants/variants_form.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:shop_app/services/graphql_service.dart';
import 'package:shop_app/size_config.dart';

import '../../../components/top_rounded_container.dart';

class VariantsWidget extends StatefulWidget {
  final String situation;
  final int productId;
  final String productTitle;
  final List<Variant> productVariants;

  const VariantsWidget({
    Key? key,
    this.situation = "product_details",
    required this.productId,
    required this.productTitle,
    required this.productVariants,
  }) : super(key: key);

  @override
  _VariantsWidgetState createState() => _VariantsWidgetState();
}

class _VariantsWidgetState extends State<VariantsWidget> {
  Map<String, dynamic> variants = {};
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);

  void _onVariantChange(String type, String value) {
    setState(() {
      variants[type] = value;
    });
  }

  void _onBuyPressed(BuildContext context) async {
    Variant selectedVariant = widget.productVariants[0];

    for (Variant variant in widget.productVariants) {
      bool matches = true;
      for (String key in variants.keys) {
        print(key);
        if (variant.get(key) != variants[key]) {
          matches = false;
          break;
        }
      }
      if (matches) {
        selectedVariant = variant;
        break;
      }
    }

    try {
      final result = await GraphQLService().queryHandler("saveOrder", {
        "product_id": widget.productId,
        "variant_id": selectedVariant.id,
        "user_id": GlobalManager().userId,
      });
      await GlobalManager().setParams(newProfileCompleted: true);

      Navigator.pushNamed(
        context,
        CheckoutScreen.routeName,
        arguments: {'variant': selectedVariant, 'orderId': result['id']},
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error processing your purchase. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final variantsWithChildren =
        getVariantsDataWithChildren(widget.productVariants);

    return (buildVariantsSectionWithButton(
        variantsWithChildren!, secondColor, context));
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
          text: "Buy Now",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": widget.productId,
            "Product Title": widget.productTitle,
            "Situation": widget.situation,
            "Variants Exist": true
          },
          press: () => _onBuyPressed(context),
        ),
      ),
    );
  }

  TopRoundedContainer buildVariantsSectionWithButton(
      Map<String, dynamic> variantsWithChildren,
      Color color,
      BuildContext context) {
    Color nextColor = color == firstColor ? secondColor : firstColor;

    return TopRoundedContainer(
      color: color,
      child: Column(children: [
        getVariantWidget(variantsWithChildren["type"],
            variantsWithChildren["values"], _onVariantChange),
        if (variantsWithChildren["child"] != null)
          buildVariantsSectionWithButton(
              variantsWithChildren["child"], nextColor, context)
        else
          buildButton(nextColor, context)
      ]),
    );
  }
}
