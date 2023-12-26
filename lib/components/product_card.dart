import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/delivery_availability_icon.dart';
import 'package:Wishy/components/request_modal.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/variants/variants_modal.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/screens/details/details_screen.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.situation,
    this.availableHeight,
    this.isFullScreen = false,
    this.isInFront = true,
    this.cursor,
  }) : super(key: key);

  final Product product;
  final bool isFullScreen;
  final double? availableHeight;
  final String situation;
  final String? cursor;
  final bool isInFront;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;
  bool _isAnalyticsSent = false;
  Color? _imageHoverColorRight = Colors.transparent;
  Color? _imageHoverColorLeft = Colors.transparent;

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
          "Situation": widget.situation,
          "Delivery Availability": GlobalManager().isDeliveryAvailable
        });
  }

  void _onRequestPressed() {
    AnalyticsService.trackEvent(analyticEvents["START_REQUEST"]!, properties: {
      "Product Id": widget.product.id,
      "Situation": widget.situation,
      "Delivery Availability": GlobalManager().isDeliveryAvailable
    });

    showRequestModal(context, widget.product.id, widget.product.title,
        widget.product.variants ?? [], widget.situation);
  }

  void _onCheckoutPressed() async {
    if (GlobalManager().isDeliveryAvailable != true) {
      await DeliveryAvailabilityDialog.show(context);

      if (!GlobalManager().isDeliveryAvailable!) {
        return;
      }
    }

    AnalyticsService.trackEvent(analyticEvents["CHECKOUT_PRESSED"]!,
        properties: {
          "Product Id": widget.product.id,
          "Situation": widget.situation,
          "Variants Exist": widget.product.variants!.length > 1,
          "Variant Picked": false,
          "Delivery Availability": GlobalManager().isDeliveryAvailable
        });

    if (widget.product.variants!.length > 1) {
      showVariantsModal(
          context,
          widget.product.id,
          widget.product.title,
          widget.product.variants!,
          widget.isFullScreen ? GlobalManager().connectUserId : null,
          widget.situation,
          cursor: widget.cursor);
    } else {
      Navigator.pushNamed(
        context,
        CheckoutScreen.routeName,
        arguments: {
          "recipientId":
              widget.isFullScreen ? GlobalManager().connectUserId : null,
          'variant': widget.product.variants![0],
          'productId': widget.product.id,
          "cursor": widget.cursor
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
                  "Situation": widget.situation,
                  "Delivery Availability": GlobalManager().isDeliveryAvailable
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
                  "Situation": widget.situation,
                  "Delivery Availability": GlobalManager().isDeliveryAvailable
                }),
            Navigator.pushNamed(
              context,
              DetailsScreen.routeName,
              arguments: ProductDetailsArguments(
                product: widget.product,
                cursor: widget.cursor,
                recipientId:
                    widget.isFullScreen ? GlobalManager().connectUserId : null,
              ),
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
                      top: 13,
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
                                margin: EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
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
                    alignment: widget.isFullScreen
                        ? Alignment.center
                        : Alignment(0, -0.7),
                    child: widget.product.images.isNotEmpty &&
                            _currentImageIndex < widget.product.images.length
                        ? Image.network(
                            widget.product.images[_currentImageIndex].url,
                            fit: BoxFit.contain,
                            height: widget.isFullScreen ? null : 160,
                          )
                        : Text(
                            "Image not available",
                          )),
                if (widget.product.images.isNotEmpty) ...[
                  generateArrow(
                      _showPreviousImage,
                      widget.isFullScreen
                          ? Alignment.centerLeft
                          : Alignment(-1.1, -0.3),
                      Icons.arrow_back_ios_new,
                      _currentImageIndex == 0,
                      left: 0),
                  generateArrow(
                      _showNextImage,
                      widget.isFullScreen
                          ? Alignment.centerRight
                          : Alignment(1.1, -0.3),
                      Icons.arrow_forward_ios,
                      _currentImageIndex == widget.product.images.length - 1,
                      right: 0,
                      isRight: true),
                ],
                Positioned(
                  bottom: widget.isFullScreen ? 30 : 60,
                  left: 5,
                  width: MediaQuery.of(context).size.width *
                      (widget.isFullScreen ? 0.6 : 0.36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DeliveryAvailabilityIcon(
                        size: widget.isFullScreen ? 20 : 15,
                      ),
                      SizedBox(height: 2),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          child: RoundedBackgroundText(
                            "${marketDetails["symbol"]}${widget.product.variants?[0].price}",
                            backgroundColor: Colors.black.withOpacity(0.5),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isFullScreen ? 16 : 13,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 5),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                          child: RoundedBackgroundText(
                            widget.product.title,
                            maxLines: 2,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: widget.isFullScreen ? 16 : 10,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                if (widget.product.likedByUserName != null)
                  Positioned.fill(
                      top: widget.isFullScreen ? 40 : 0,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              SvgPicture.asset(
                                "assets/icons/Heart Icon_2.svg",
                                color: Colors.white,
                                height: getProportionateScreenWidth(16),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              Text(
                                "${widget.product.likedByUserName}'s Wishes",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: widget.isFullScreen ? 13 : 11,
                                ),
                              ),
                            ]),
                          ))),
                if (widget.product.variants == null)
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment(0.8, 0.9),
                        child: Text("Out of stock",
                            style: TextStyle(color: Colors.red))),
                  ),
                if (widget.product.variants != null) ...[
                  Positioned(
                      right: widget.isFullScreen ? 20 : 0,
                      bottom: widget.isFullScreen ? 40 : 10,
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
                          child: SvgPicture.asset(
                            "assets/icons/buy_now.svg",
                            color: Colors.black,
                            height: widget.isFullScreen ? 50 : 25,
                          ),
// Icon(
//                             Icons.card_giftcard,
//                             color: Colors.black,
//                             size: widget.isFullScreen ? 50 : 25,
//                           ),
                        ),
                      )),
                  if (!widget.isFullScreen && GlobalManager().signedIn)
                    Positioned(
                        left: 0,
                        bottom: 10,
                        child: ElevatedButton(
                          onPressed: () {
                            _onRequestPressed();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: CircleBorder(),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: SvgPicture.asset(
                              "assets/icons/request.svg",
                              color: Colors.black,
                              height: 39,
                            ),
                          ),
                        )),
                  if (widget.product.followerId != null)
                    Align(
                        alignment: Alignment.topCenter,
                        child: Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.product.followerName! + " likes too",
                              textAlign: TextAlign.center,
                              // style: TextStyle(fontSize: 24),
                            ),
                          ),
                        )),
                ],
                Positioned.fill(
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        // color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget generateArrow(void Function()? callback, AlignmentGeometry alignment,
      IconData icon, bool disable,
      {double? left, double? right, bool isRight = false}) {
    return Positioned.fill(
        left: left,
        right: right,
        child: Align(
            alignment: alignment,
            child: GestureDetector(
                onTapUp: disable
                    ? null
                    : (e) {
                        setState(() {
                          _imageHoverColorLeft = Colors.transparent;
                          _imageHoverColorRight = Colors.transparent;
                        });
                        callback!();
                      },
                onTapDown: disable
                    ? null
                    : (e) {
                        setState(() {
                          setState(() {
                            _imageHoverColorLeft =
                                isRight ? Colors.transparent : Colors.white;
                            _imageHoverColorRight =
                                isRight ? Colors.white : Colors.transparent;
                          });
                        });
                      },
                child: CircleAvatar(
                  backgroundColor:
                      isRight ? _imageHoverColorRight : _imageHoverColorLeft,
                  child: Icon(
                    icon,
                    color: disable ? Colors.grey : Colors.black,
                  ),
                ))));
  }
}
