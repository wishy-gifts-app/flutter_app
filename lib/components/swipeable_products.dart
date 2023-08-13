import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeableCardWidget extends StatefulWidget {
  final List<Product> products;
  final Function(String) onSwipeRight;
  final Function(String) onSwipeLeft;
  final Function(String) onSwipeUp;

  SwipeableCardWidget({
    required this.products,
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
  });

  @override
  _SwipeableCardWidgetState createState() => _SwipeableCardWidgetState();
}

class _SwipeableCardWidgetState extends State<SwipeableCardWidget> {
  List<SwipeItem> _swipeItems = [];
  MatchEngine? _matchEngine;

  @override
  void initState() {
    super.initState();
    for (var product in widget.products) {
      _swipeItems.add(SwipeItem(
        content: product,
        likeAction: () {
          widget.onSwipeRight(product.id.toString());
        },
        nopeAction: () {
          widget.onSwipeLeft(product.id.toString());
        },
        superlikeAction: () {
          widget.onSwipeUp(product.id.toString());
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SwipeCards(
        onStackFinished: () {
          print("Stack Finished");
        },
        matchEngine: _matchEngine!,
        upSwipeAllowed: true,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              ProductCard(
                product: _swipeItems[index].content as Product,
                isFullScreen: true,
                availableHeight: constraints.maxHeight,
              ),
              Positioned(
                  right: 20, // Horizontal position
                  bottom: 30, // Vertical position
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: Colors.black, // Text color
                      shape: CircleBorder(), // Button shape
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          8.0), // You can adjust the value as needed
                      child: Icon(
                        Icons.card_giftcard,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  )),
            ],
          );
        },
      );
    });
  }
}
