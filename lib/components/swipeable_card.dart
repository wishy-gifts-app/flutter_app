import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeableCardWidget extends StatefulWidget {
  final Function(int) onSwipeRight;
  final Function(int) onSwipeLeft;
  final Function(int) onSwipeUp;
  final List<Product> items;
  final Widget Function(BuildContext context, Product product) cardBuilder;

  SwipeableCardWidget({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.items,
    required this.cardBuilder,
  });

  @override
  _SwipeableCardWidgetState createState() => _SwipeableCardWidgetState();
}

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

class _SwipeableCardWidgetState extends State<SwipeableCardWidget> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  void initState() {
    _swipeItems = buildSwipeItems(widget.items, widget.onSwipeRight,
        widget.onSwipeLeft, widget.onSwipeUp, context);
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SwipeCards(
      onStackFinished: () => print("Finished page"),
      matchEngine: _matchEngine!,
      itemBuilder: (BuildContext context, int index) {
        return widget.cardBuilder(
            context, _swipeItems[index].content as Product);
      },
      leftSwipeAllowed: true,
      rightSwipeAllowed: true,
      upSwipeAllowed: true,
      fillSpace: true,
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
    ));
  }
}
