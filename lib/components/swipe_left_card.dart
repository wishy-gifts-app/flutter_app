import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/models/utils.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/analytics.dart';

class SwipeableLeftProducts<T extends Identifiable> extends StatefulWidget {
  final Function(int) onSwipeLeft;
  final Future<List<T>?> Function() nextPage;
  final Widget Function(BuildContext context, T item) cardBuilder;
  final String emptyString, emptyCTA;
  final String? emptyTitle;
  final String situation;

  SwipeableLeftProducts({
    required this.onSwipeLeft,
    required this.nextPage,
    required this.cardBuilder,
    required this.situation,
    this.emptyString = "Sorry, but we don't have products yet",
    this.emptyTitle,
    this.emptyCTA = "Browse Products",
  });

  @override
  _SwipeableLeftProductsState<T> createState() =>
      _SwipeableLeftProductsState<T>();
}

class _SwipeableLeftProductsState<T extends Identifiable>
    extends State<SwipeableLeftProducts<T>> with TickerProviderStateMixin {
  late AnimationController _controller;
  List<T> products = [];
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
      return isLoading
          ? Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: CircularProgressIndicator()))
          : EmptyStateWidget(
              body: widget.emptyString,
              title: widget.emptyTitle,
              CTA: widget.emptyCTA,
              routeName: HomeScreen.routeName);
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
              (MediaQuery.of(context).size.height / 1.22),
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
        ),
        padding: EdgeInsets.all(5),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Text(
                'Dislike',
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
