import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/components/swipeable_card.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/utils/analytics.dart';

class SwipeableProducts extends StatefulWidget {
  final bool isFullPage;
  final Function(int) onSwipeRight;
  final Function(int) onSwipeLeft;
  final Function(int) onSwipeUp;
  final Future<List<Product>?> Function() nextPage;
  final Widget Function(BuildContext context, Product product) cardBuilder;
  final String emptyString;
  final String situation;

  SwipeableProducts({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.nextPage,
    required this.cardBuilder,
    required this.situation,
    this.emptyString = "Sorry, but we don't have products yet",
    this.isFullPage = true,
  });

  @override
  _SwipeableProductsState createState() => _SwipeableProductsState();
}

class _SwipeableProductsState extends State<SwipeableProducts> {
  List<Product> products = [];
  bool isStateEmpty = false;

  void onSwipeRight(int productId) {
    widget.onSwipeRight(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_RIGHT"]!,
        properties: {"Product Id": productId, "Situation": widget.situation});
  }

  void onSwipeLeft(int productId) {
    widget.onSwipeRight(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_LEFT"]!,
        properties: {"Product Id": productId, "Situation": widget.situation});
  }

  void onSwipeUp(int productId) {
    widget.onSwipeRight(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_UP"]!,
        properties: {"Product Id": productId, "Situation": widget.situation});
  }

  Future<void> fetchProductsItems() async {
    final results = await widget.nextPage();

    if (mounted) {
      if (results != null && results.length > 0) {
        setState(() {
          products = results;
          isStateEmpty = false;
        });
      } else {
        setState(() {
          isStateEmpty = products.length == 0;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsItems();
  }

  @override
  Widget build(BuildContext context) {
    if (products.length == 0) {
      return Center(
          child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: !isStateEmpty
            ? CircularProgressIndicator()
            : Text(
                widget.emptyString!,
                textAlign: TextAlign.center,
              ),
      ));
    }

    if (widget.isFullPage) {
      return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SwipeableCardWidget(
            onSwipeRight: onSwipeRight,
            onSwipeLeft: onSwipeLeft,
            onSwipeUp: onSwipeUp,
            items: products,
            cardBuilder: widget.cardBuilder,
          ));
    } else {
      return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.3),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            padding: EdgeInsets.all(5),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return SwipeableCardWidget(
                onSwipeRight: widget.onSwipeRight,
                onSwipeLeft: widget.onSwipeLeft,
                onSwipeUp: widget.onSwipeUp,
                items: [products[index]],
                cardBuilder: widget.cardBuilder,
              );
            },
          ));
    }
  }
}
