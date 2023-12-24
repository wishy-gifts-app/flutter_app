import 'package:Wishy/components/swipe_tutorial_overlay.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:swipe_cards/swipe_cards.dart';

List<SwipeItem> buildSwipeItems(
    List<Product> items,
    Function(int) onSwipeRight,
    Function(int) onSwipeLeft,
    Function(Product) onSwipeUp,
    BuildContext context) {
  List<SwipeItem> swipeItems = [];
  for (var item in items) {
    swipeItems.add(SwipeItem(
      content: item,
      likeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[900],
          content: Text("Like saved"),
          duration: Duration(milliseconds: 500),
        ));

        onSwipeRight(item.id);
      },
      nopeAction: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[900],
          content: Text("Nope saved"),
          duration: Duration(milliseconds: 500),
        ));

        onSwipeLeft(item.id);
      },
      superlikeAction: () {
        onSwipeUp(item);
      },
    ));
  }
  return swipeItems;
}

class SwipeableProducts extends StatefulWidget {
  final Function(int) onSwipeRight;
  final Function(int) onSwipeLeft;
  final Function(Product) onSwipeUp;
  final Future<List<Product>?> Function() nextPage;
  final Widget Function(BuildContext context, Product product, bool isInFront)
      cardBuilder;
  final String emptyString;
  final String situation;
  final bool showAnimation;

  SwipeableProducts({
    Key? key,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.nextPage,
    required this.cardBuilder,
    required this.situation,
    this.emptyString = "Sorry, but we don't have products yet",
    this.showAnimation = true,
  }) : super(key: key);

  @override
  _SwipeableProductsState createState() => _SwipeableProductsState();
}

class _SwipeableProductsState extends State<SwipeableProducts> {
  List<SwipeItem> _currentSwipeItems = <SwipeItem>[];
  List<SwipeItem> _nextSwipeItems = <SwipeItem>[];
  MatchEngine? _currentMatchEngine;
  MatchEngine? _nextMatchEngine;
  bool isStateEmpty = false;
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  bool _isFirstCard = true;

  @override
  void dispose() {
    currentIndex.dispose();
    super.dispose();
  }

  void onSwipeRight(int productId) {
    widget.onSwipeRight(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_RIGHT"]!, properties: {
      "Product Id": productId,
      "Situation": widget.situation,
      "Delivery Availability": GlobalManager().isDeliveryAvailable
    });
  }

  void onSwipeLeft(int productId) {
    widget.onSwipeLeft(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_LEFT"]!, properties: {
      "Product Id": productId,
      "Situation": widget.situation,
      "Delivery Availability": GlobalManager().isDeliveryAvailable
    });
  }

  void onSwipeUp(Product product) {
    widget.onSwipeUp(product);
    AnalyticsService.trackEvent(analyticEvents["START_REQUEST"]!, properties: {
      "Product Id": product.id,
      "Situation": widget.situation,
      "Delivery Availability": GlobalManager().isDeliveryAvailable
    });
  }

  Future<void> _fetchItems() async {
    final results = await widget.nextPage();

    if (mounted) {
      if (results != null && results.length > 0) {
        setState(() {
          _currentSwipeItems = buildSwipeItems(
              results, onSwipeRight, onSwipeLeft, onSwipeUp, context);
          _currentMatchEngine = MatchEngine(swipeItems: _currentSwipeItems);
          isStateEmpty = false;
        });
      } else {
        setState(() {
          isStateEmpty = true;
        });
      }
    }
  }

  void _fetchNextItems() async {
    final nextResults = await widget.nextPage();

    if (mounted) {
      if (nextResults != null && nextResults.length > 0) {
        setState(() {
          _nextSwipeItems = buildSwipeItems(
              nextResults, onSwipeRight, onSwipeLeft, onSwipeUp, context);
          _nextMatchEngine = MatchEngine(swipeItems: _nextSwipeItems);
          isStateEmpty = false;
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
    _fetchItems().then((value) => _fetchNextItems());
  }

  @override
  Widget build(BuildContext context) {
    if ((_isFirstCard && _currentSwipeItems.length == 0) ||
        (!_isFirstCard && _nextSwipeItems.length == 0)) {
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

    return Stack(children: [
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Container(
              child: Stack(children: [
            if (_nextMatchEngine != null && !_isFirstCard)
              _buildSwipeCards(_nextMatchEngine!, _nextSwipeItems, () {
                setState(() {
                  _isFirstCard = true;
                });

                _fetchNextItems();
              }),
            if (_currentMatchEngine != null && _isFirstCard)
              _buildSwipeCards(_currentMatchEngine!, _currentSwipeItems, () {
                setState(() {
                  _isFirstCard = false;
                });

                _fetchItems();
              }),
            if (_nextMatchEngine != null && _isFirstCard)
              _buildSwipeCards(_nextMatchEngine!, _nextSwipeItems, () {
                setState(() {
                  _isFirstCard = false;
                });

                _fetchNextItems();
              }),
            if (_currentMatchEngine != null && !_isFirstCard)
              _buildSwipeCards(_currentMatchEngine!, _currentSwipeItems, () {
                setState(() {
                  _isFirstCard = true;
                });

                _fetchItems();
              }),
          ]))),
    ]);
  }

  SwipeCards _buildSwipeCards(
      MatchEngine matchEngine, List<SwipeItem> swipeItems, Function refetch) {
    return SwipeCards(
      onStackFinished: () {
        setState(() {
          _isFirstCard = !this._isFirstCard;
        });

        refetch();
      },
      matchEngine: matchEngine,
      itemBuilder: (BuildContext context, int index) {
        return widget.cardBuilder(context, swipeItems[index].content as Product,
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
    );
  }
}
