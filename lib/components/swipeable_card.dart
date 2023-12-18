import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';
import 'package:swipe_cards/swipe_cards.dart';

List<SwipeItem> buildSwipeItems(List<dynamic> items, Function() onSwipeRight,
    Function() onSwipeLeft, BuildContext context) {
  List<SwipeItem> swipeItems = [];
  for (var item in items) {
    swipeItems.add(SwipeItem(
      content: item,
      likeAction: () {
        onSwipeRight();
      },
      nopeAction: () {
        onSwipeLeft();
      },
    ));
  }
  return swipeItems;
}

class SwipeableCard extends StatefulWidget {
  final Function() onSwipeRight;
  final Function() onSwipeLeft;
  final List<InteractiveCardData> items;
  final Widget Function(BuildContext context, InteractiveCardData item)
      cardBuilder;

  SwipeableCard({
    Key? key,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.cardBuilder,
    required this.items,
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  @override
  void initState() {
    super.initState();
    _swipeItems = buildSwipeItems(
        widget.items, widget.onSwipeRight, widget.onSwipeLeft, context);
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: Container(
            height: MediaQuery.of(context).size.height - 169,
            width: MediaQuery.of(context).size.width - 19,
            child: SwipeCards(
              onStackFinished: () => {},
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return widget.cardBuilder(
                  context,
                  _swipeItems[index].content as InteractiveCardData,
                );
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: false,
              fillSpace: true,
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
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: Text('Nope'),
              ),
            )));
  }
}
