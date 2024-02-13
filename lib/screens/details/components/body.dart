import 'package:Wishy/components/variants/buy_now_widget.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/additional_details_dialog.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';
import 'product_description.dart';
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
  int _selectedImageIndex = 0;
  ScrollController _scrollController = ScrollController();
  ScrollController _imagesScrollController = ScrollController();
  CarouselController _imagesCarouselController = CarouselController();
  GlobalKey buyNowWidgetKey = GlobalKey();
  bool isBuyNowVisible = false;

  void _scrollListener() {
    var renderBox =
        buyNowWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      var position = renderBox.localToGlobal(Offset.zero);
      var screenHeight = MediaQuery.of(context).size.height;

      // Adjust these values as needed to fine-tune when the FAB should hide
      var isVisible = position.dy < screenHeight;

      setState(() {
        isBuyNowVisible = isVisible;
      });
    }
  }

  void _sendImageViewedEvent() {
    AnalyticsService.trackEvent(analyticEvents["PRODUCT_IMAGE_VIEWED"]!,
        properties: {
          'Product Id': widget.product.id,
          'Product Title': widget.product.title,
          'Image Url': widget.product.images.isNotEmpty
              ? widget.product.images[_selectedImageIndex].url
              : null,
          "Situation": situation
        });
  }

  void _onImageChange(int index) {
    setState(() {
      _selectedImageIndex = index;
    });

    double position = index * (getProportionateScreenWidth(48) + 15);
    _imagesScrollController.animateTo(
      position,
      duration: defaultDuration,
      curve: Curves.easeInOut,
    );
    _sendImageViewedEvent();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView(
        controller: _scrollController,
        children: [
          ProductImages(
            carouselController: _imagesCarouselController,
            scrollController: _imagesScrollController,
            onImageChange: _onImageChange,
            selectedImage: _selectedImageIndex,
            product: widget.product,
          ),
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
                      description:
                          widget.product.additionalData.anotherDetails ?? "",
                    );
                  },
                );
              },
              childBuilder: (color) => BuyNowWidget(
                  buttonKey: buyNowWidgetKey,
                  startColor: color,
                  situation: situation,
                  product: widget.product,
                  chosenVariantId: widget.variantId,
                  recipientId: widget.recipientId)),
        ],
      ),
      if (!isBuyNowVisible)
        Positioned(
            right: 15,
            bottom: 50,
            child: BuyNowIcon(
              height: 50,
              situation: situation,
              product: widget.product,
              cursor: widget.cursor,
              recipientId: GlobalManager().connectUserId,
            ))
    ]);
  }
}
