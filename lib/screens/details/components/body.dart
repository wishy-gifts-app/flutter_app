import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/additional_details_dialog.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';

import 'product_description.dart';
import '../../../components/top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final situation = "product_details";
  final Product product;
  final int? variantId, recipientId;
  final String buttonText;
  final String? cursor;

  Body(
      {Key? key,
      required this.product,
      this.buttonText = "Buy Now",
      this.variantId,
      this.cursor,
      this.recipientId})
      : super(key: key);
  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(product: product),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: product,
                pressOnSeeMore: () {
                  AnalyticsService.trackEvent(
                      analyticEvents["SHOW_MORE_PRODUCT_DESCRIPTION"]!,
                      properties: {
                        "Product Id": product.id,
                        "Delivery Availability":
                            GlobalManager().isDeliveryAvailable
                      });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AdditionalDetailsDialog(
                        description: product.description ?? "",
                      );
                    },
                  );
                },
              ),
              if (product.variants == null)
                buildOutOfStock(secondColor)
              else if (product.variants!.length > 1)
                VariantsWidget(
                    situation: situation,
                    productId: product.id,
                    productTitle: product.title,
                    productVariants: product.variants!,
                    buttonText: this.buttonText,
                    variantId: this.variantId,
                    recipientId: recipientId)
              else
                buildButton(secondColor, context)
            ],
          ),
        ),
      ],
    );
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
              "${this.buttonText} ${marketDetails["symbol"]}${product.variants![0].price}",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": product.id,
            "Product Title": product.title,
            "Situation": situation,
            "Variants Exist": false,
            "Variant Picked": false,
            "Delivery Availability": GlobalManager().isDeliveryAvailable
          },
          press: () async {
            if (!GlobalManager().isDeliveryAvailable!) {
              await DeliveryAvailabilityDialog.show(context);

              if (!GlobalManager().isDeliveryAvailable!) return;
            }

            Navigator.pushNamed(
              context,
              CheckoutScreen.routeName,
              arguments: {
                'variant': product.variants![0],
                'productId': product.id,
                'recipientId': recipientId,
                "cursor": cursor
              },
            );
          },
        ),
      ),
    );
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
}
