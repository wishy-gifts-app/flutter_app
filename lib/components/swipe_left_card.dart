import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/utils/analytics.dart';

class SwipeableLeftProducts extends StatefulWidget {
  final Function(int) onSwipeRight;
  final Function(int) onSwipeLeft;
  final Function(int) onSwipeUp;
  final Future<List<Product>?> Function() nextPage;
  final Widget Function(BuildContext context, Product product) cardBuilder;
  final String emptyString;
  final String situation;

  SwipeableLeftProducts({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.nextPage,
    required this.cardBuilder,
    required this.situation,
    this.emptyString = "Sorry, but we don't have products yet",
  });

  @override
  _SwipeableLeftProductsState createState() => _SwipeableLeftProductsState();
}

class _SwipeableLeftProductsState extends State<SwipeableLeftProducts>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Product> products = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchProducts();
      }
    });
  }

  _fetchProducts() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var fetchedProducts = await widget.nextPage();
      setState(() {
        isLoading = false;
      });

      if (fetchedProducts != null) {
        setState(() {
          products.addAll(fetchedProducts);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (products.length == 0) {
      return Center(
          child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
                widget.emptyString,
                textAlign: TextAlign.center,
              ),
      ));
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
      ),
      child: GridView.builder(
        controller: _scrollController,
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
          return Dismissible(
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                'Nope',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            key: UniqueKey(),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: widget.cardBuilder(
                context,
                products[index],
              ),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                widget.onSwipeLeft(products[index].id);
                AnalyticsService.trackEvent(analyticEvents["SWIPED_LEFT"]!,
                    properties: {
                      "Product Id": products[index].id,
                      "Situation": widget.situation
                    });

                setState(() {
                  products.removeAt(index);
                });
              }
              return Future.value(false);
            },
          );
        },
      ),
    );
  }
}
