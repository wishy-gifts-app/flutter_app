import 'package:Wishy/components/swipe_tutorial_overlay.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
          content: Text("Like saved"),
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
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  bool isStateEmpty = false;
  late bool _showAnimation = GlobalManager().showAnimation;
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
    widget.onSwipeLeft(productId);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_LEFT"]!,
        properties: {"Product Id": productId, "Situation": widget.situation});
  }

  void onSwipeUp(Product product) {
    widget.onSwipeUp(product);
    AnalyticsService.trackEvent(analyticEvents["SWIPED_UP"]!,
        properties: {"Product Id": product.id, "Situation": widget.situation});
  }

  Future<void> fetchItems() async {
    final results = await widget.nextPage();

    if (mounted) {
      if (results != null && results.length > 0) {
        currentIndex.value = 0;
        setState(() {
          isStateEmpty = false;
          _swipeItems = buildSwipeItems(
              results, onSwipeRight, onSwipeLeft, onSwipeUp, context);
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

    return Stack(children: [
      Padding(
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
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.green)),
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
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.orange)),
              child: Text('Request'),
            ),
          ))),
      if (_showAnimation)
        SwipeTutorialOverlay(onFinished: () {
          setState(() {
            this._showAnimation = false;
          });
          GlobalManager().setShowAnimation(false);
        }),
    ]);
  }
}
