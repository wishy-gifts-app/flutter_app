import 'package:flutter/material.dart';
import 'package:shop_app/components/variants/variants_modal.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/utils/analytics.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.situation,
    this.availableHeight,
    this.isFullScreen = false,
    this.isInFront = true,
  }) : super(key: key);

  final Product product;
  final bool isFullScreen;
  final double? availableHeight;
  final String situation;
  final bool isInFront;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;
  bool _isAnalyticsSent = false;

  @override
  void initState() {
    super.initState();
  }

  void _showPreviousImage() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });

      _sendImageViewedEvent();
    }
  }

  void _showNextImage() {
    if (_currentImageIndex < widget.product.images.length - 1) {
      setState(() {
        _currentImageIndex++;
      });

      _sendImageViewedEvent();
    }
  }

  void _sendImageViewedEvent() {
    AnalyticsService.trackEvent(analyticEvents["PRODUCT_IMAGE_VIEWED"]!,
        properties: {
          'Product Id': widget.product.id,
          'Product Title': widget.product.title,
          'Image Url': widget.product.images.isNotEmpty
              ? widget.product.images[_currentImageIndex].url
              : null,
          "Situation": widget.situation
        });
  }

  void _onCheckoutPressed() async {
    if (widget.product.variants.length > 1) {
      showVariantsModal(context, widget.product.id, widget.product.title,
          widget.product.variants);
    } else {
      AnalyticsService.trackEvent(analyticEvents["CHECKOUT_PRESSED"]!,
          properties: {
            "Product Id": widget.product.id,
            "Situation": widget.situation,
            "Variants Exist": false
          });

      Navigator.pushNamed(
        context,
        CheckoutScreen.routeName,
        arguments: {
          'variant': widget.product.variants[0],
          'productId': widget.product.id
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key('product-card-${widget.product.id}-${widget.isInFront}'),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 1 &&
              widget.isInFront &&
              !_isAnalyticsSent) {
            AnalyticsService.trackEvent(analyticEvents["PRODUCT_VIEWED"]!,
                properties: {
                  'Product Id': widget.product.id,
                  'Product Title': widget.product.title,
                  "Situation": widget.situation
                });

            _sendImageViewedEvent();
            setState(() {
              _isAnalyticsSent = true;
            });
          }
        },
        child: GestureDetector(
          onTap: () => {
            AnalyticsService.trackEvent(
                analyticEvents["PRODUCT_DETAILS_PRESSED"]!,
                properties: {
                  "Product Id": widget.product.id,
                  'Product Title': widget.product.title,
                  "Situation": widget.situation
                }),
            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: ProductDetailsArguments(product: widget.product),
            )
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (widget.isFullScreen)
                  Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: widget.product.images.map((image) {
                            final index = widget.product.images.indexOf(image);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              child: Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _currentImageIndex == index
                                        ? kPrimaryColor
                                        : Colors.grey,
                                    width: 2,
                                  ),
                                  color: _currentImageIndex == index
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                Align(
                  alignment: Alignment.center,
                  child: widget.product.images.isNotEmpty &&
                          _currentImageIndex < widget.product.images.length
                      ? Image.network(
                          widget.product.images[_currentImageIndex].url,
                          fit: BoxFit.contain,
                        )
                      : Text(
                          "Image not available",
                        ),
                ),
                if (widget.product.images.isNotEmpty)
                  Positioned.fill(
                    left: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _showPreviousImage,
                        disabledColor: Colors.grey,
                        color: _currentImageIndex == 0 ? Colors.grey : null,
                      ),
                    ),
                  ),
                if (widget.product.images.isNotEmpty)
                  Positioned.fill(
                    right: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _showNextImage,
                        disabledColor: Colors.grey,
                        color: _currentImageIndex ==
                                widget.product.images.length - 1
                            ? Colors.grey
                            : null,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  width: MediaQuery.of(context).size.width *
                      (widget.isFullScreen ? 0.6 : 0.24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "\$ ${widget.product.price}",
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.product.title,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Positioned(
                    right: widget.isFullScreen ? 20 : 0,
                    bottom: widget.isFullScreen ? 40 : 15,
                    child: ElevatedButton(
                      onPressed: () {
                        _onCheckoutPressed();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: CircleBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.card_giftcard,
                          color: Colors.black,
                          size: widget.isFullScreen ? 50 : 25,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
