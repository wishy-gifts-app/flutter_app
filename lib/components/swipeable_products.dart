import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipeableCardWidget extends StatefulWidget {
  final Function(String) onSwipeRight;
  final Function(String) onSwipeLeft;
  final Function(String) onSwipeUp;
  final Function() nextPage;

  SwipeableCardWidget({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.nextPage,
  });

  @override
  _SwipeableCardWidgetState createState() => _SwipeableCardWidgetState();
}

List<SwipeItem> buildSwipeItems(
  List<Product> products,
  Function(String) onSwipeRight,
  Function(String) onSwipeLeft,
  Function(String) onSwipeUp,
) {
  List<SwipeItem> swipeItems = [];
  for (var product in products) {
    swipeItems.add(SwipeItem(
      content: product,
      likeAction: () {
        onSwipeRight(product.id.toString());
      },
      nopeAction: () {
        onSwipeLeft(product.id.toString());
      },
      superlikeAction: () {
        onSwipeUp(product.id.toString());
      },
    ));
  }
  return swipeItems;
}

class _SwipeableCardWidgetState extends State<SwipeableCardWidget> {
  List<SwipeItem> _swipeItems = [];
  MatchEngine? _matchEngine;
  List<Product> products = [];

  Future<void> setProductsItems() async {
    final products = await widget.nextPage();

    if (products != null) {
      final result = buildSwipeItems(
        products,
        widget.onSwipeRight,
        widget.onSwipeLeft,
        widget.onSwipeUp,
      );

      if (mounted) {
        setState(() {
          _swipeItems = result;
          _matchEngine = MatchEngine(swipeItems: _swipeItems);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setProductsItems();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (_swipeItems.length == 0) {
        return Center(
          child: CircularProgressIndicator(), // Display loading indicator
        );
      }

      return SwipeCards(
        onStackFinished: setProductsItems,
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
