import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:Wishy/utils/is_variants_exists.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

class Body extends StatefulWidget {
  final Product product;
  final int? variantId, recipientId;
  final String buttonText;
  final String? cursor;

  Body({
    Key? key,
    required this.product,
    this.buttonText = "Buy Now",
    this.variantId,
    this.cursor,
    this.recipientId,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final situation = "product_details";
  int? _selectedImageIndex = null;
  ScrollController _scrollController = ScrollController();
  CarouselController _carouselController = CarouselController();

  final firstColor = Colors.white;
  final secondColor = Color(0xFFF6F7F9);

  void _sendImageViewedEvent() {
    AnalyticsService.trackEvent(analyticEvents["PRODUCT_IMAGE_VIEWED"]!,
        properties: {
          'Product Id': widget.product.id,
          'Product Title': widget.product.title,
          'Image Url': widget.product.images.isNotEmpty
              ? widget.product.images[_selectedImageIndex ?? 0].url
              : null,
          "Situation": situation
        });
  }

  void _onImageChange(int index) {
    setState(() {
      _selectedImageIndex = index;
    });

    double position = index * (getProportionateScreenWidth(48) + 15);
    _scrollController.animateTo(
      position,
      duration: defaultDuration,
      curve: Curves.easeInOut,
    );
    _sendImageViewedEvent();
  }

  void _onVariantChange(Variant? v) {
    int index = 0;
    if (v == null) return;

    if (v.imageId != null) {
      index = widget.product.images
          .indexWhere((element) => element.id == v.imageId);
    }

    _carouselController.jumpToPage(index);
    _onImageChange(index);
  }

  @override
  void initState() {
    if (_selectedImageIndex == null)
      Future.delayed(
          Duration.zero, () => _onVariantChange(widget.product.variants![0]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(
          carouselController: _carouselController,
          scrollController: _scrollController,
          onImageChange: _onImageChange,
          selectedImage: _selectedImageIndex ?? 0,
          product: widget.product,
        ),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(
                product: widget.product,
                pressOnSeeMore: () {
                  AnalyticsService.trackEvent(
                      analyticEvents["SHOW_MORE_PRODUCT_DESCRIPTION"]!,
                      properties: {
                        "Product Id": widget.product.id,
                        "Delivery Availability":
                            GlobalManager().isDeliveryAvailable
                      });

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AdditionalDetailsDialog(
                        description: widget.product.description ?? "",
                      );
                    },
                  );
                },
              ),
              if (widget.product.variants == null)
                buildOutOfStock(secondColor)
              else if (isVariantsExists(widget.product.variants))
                VariantsWidget(
                    onVariantChange: _onVariantChange,
                    situation: situation,
                    product: widget.product,
                    buttonText: widget.buttonText,
                    variantId: widget.variantId,
                    recipientId: widget.recipientId)
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
              "${widget.buttonText} ${marketDetails["symbol"]}${widget.product.variants![0].price}",
          eventName: analyticEvents["CHECKOUT_PRESSED"]!,
          eventData: {
            "Product Id": widget.product.id,
            "Product Title": widget.product.title,
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
                'variant': widget.product.variants![0],
                'productId': widget.product.id,
                'recipientId': widget.recipientId,
                "cursor": widget.cursor
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
