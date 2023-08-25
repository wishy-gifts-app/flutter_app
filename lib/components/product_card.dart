import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import '../size_config.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.product,
    this.availableHeight,
    this.isFullScreen = false,
  }) : super(key: key);

  final Product product;
  final bool isFullScreen;
  final double? availableHeight;

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _currentImageIndex = 0;

  void _showPreviousImage() {
    if (_currentImageIndex > 0) {
      setState(() {
        _currentImageIndex--;
      });
    }
  }

  void _showNextImage() {
    if (_currentImageIndex < widget.product.images.length - 1) {
      setState(() {
        _currentImageIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        DetailsScreen.routeName,
        arguments: ProductDetailsArguments(product: widget.product),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (widget.isFullScreen)
              Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.product.images.map((image) {
                        final index = widget.product.images.indexOf(image);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          child: Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _currentImageIndex == index
                                    ? kPrimaryColor // Change the color of the active circle
                                    : Colors
                                        .grey, // Change the color of the inactive circles
                                width: 2,
                              ),
                              color: _currentImageIndex == index
                                  ? kPrimaryColor // Fill the active circle
                                  : Colors
                                      .transparent, // Leave the inactive circles empty
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )),
            Align(
              alignment: Alignment.center,
              child: widget.product.images.isNotEmpty &&
                      _currentImageIndex < widget.product.images.length
                  ? Image.network(
                      widget.product.images[_currentImageIndex].url,
                      fit: BoxFit.contain,
                    )
                  : Text(
                      "Image not available", // You can customize the message here
                      style: TextStyle(color: Colors.black),
                    ),
            ),
            if (widget.product.images.isNotEmpty)
              Positioned.fill(
                left: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: _showPreviousImage,
                    disabledColor: Colors.grey,
                    color: _currentImageIndex == 0 ? Colors.grey : null,
                  ),
                ),
              ),
            if (widget.product.images.isNotEmpty)
              Positioned.fill(
                right: 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: _showNextImage,
                    disabledColor: Colors.grey,
                    color:
                        _currentImageIndex == widget.product.images.length - 1
                            ? Colors.grey
                            : null,
                  ),
                ),
              ),
            Positioned(
              bottom: 30,
              left: 20,
              width: MediaQuery.of(context).size.width *
                  (widget.isFullScreen ? 0.6 : 0.24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "\$ ${widget.product.price}",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.product.title,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Positioned(
                right: widget.isFullScreen ? 20 : 0, // Horizontal position
                bottom: widget.isFullScreen ? 40 : 15, // Vertical position
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
                      size: widget.isFullScreen ? 50 : 25,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
