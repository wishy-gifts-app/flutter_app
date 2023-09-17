import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/utils/analytics.dart';
import 'package:swipe_cards/swipe_cards.dart';

List<SwipeItem> buildSwipeItems(List<Product> items, Function(int) onSwipeRight,
    Function(int) onSwipeLeft, Function(int) onSwipeUp, BuildContext context) {
  List<SwipeItem> swipeItems = [];
  for (var item in items) {
    swipeItems.add(SwipeItem(
      content: item,
      likeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Liked saved"),
          duration: Duration(milliseconds: 500),
        ));

        onSwipeRight(item.id);
      },
      nopeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Nope saved"),
          duration: Duration(milliseconds: 500),
        ));

        onSwipeLeft(item.id);
      },
      superlikeAction: () {
        onSwipeUp(item.id);
      },
    ));
  }
  return swipeItems;
}

class SwipeableProducts extends StatefulWidget {
  final Function(int) onSwipeRight;
  final Function(int) onSwipeLeft;
  final Function(int) onSwipeUp;
  final Future<List<Product>?> Function() nextPage;
  final Widget Function(BuildContext context, Product product, bool isInFront)
      cardBuilder;
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
  });

  @override
  _SwipeableProductsState createState() => _SwipeableProductsState();
}

class _SwipeableProductsState extends State<SwipeableProducts> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  bool isStateEmpty = false;
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    currentIndex.dispose();
    super.dispose();
  }

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

  Future<void> fetchItems() async {
    final results = await widget.nextPage();

    if (mounted) {
      if (results != null && results.length > 0) {
        currentIndex.value = 0;
        setState(() {
          isStateEmpty = false;
          _swipeItems = buildSwipeItems(results, widget.onSwipeRight,
              widget.onSwipeLeft, widget.onSwipeUp, context);
          _matchEngine = MatchEngine(swipeItems: _swipeItems);
        });
      } else {
        setState(() {
          isStateEmpty = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    if (_swipeItems.length == 0) {
      return Center(
          child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: !isStateEmpty
            ? CircularProgressIndicator()
            : Text(
                widget.emptyString,
                textAlign: TextAlign.center,
              ),
      ));
    }

    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: Container(
            child: SwipeCards(
          onStackFinished: fetchItems,
          matchEngine: _matchEngine!,
          itemBuilder: (BuildContext context, int index) {
            return widget.cardBuilder(
                context,
                _swipeItems[index].content as Product,
                currentIndex.value == index);
          },
          leftSwipeAllowed: true,
          rightSwipeAllowed: true,
          upSwipeAllowed: true,
          fillSpace: true,
          itemChanged: (SwipeItem item, int index) {
            if (index != currentIndex.value) {
              currentIndex.value = index;
            }
          },
          likeTag: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.green)),
            child: Text('Like'),
          ),
          nopeTag: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Text('Nope'),
          ),
          superLikeTag: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
            child: Text('Request'),
          ),
        )));
  }
}
