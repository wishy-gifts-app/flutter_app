import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  CarouselController _carouselController = CarouselController();
  ScrollController _scrollController = ScrollController();
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.id.toString(),
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectedImage = index;
                    });
                    double position =
                        index * (getProportionateScreenWidth(48) + 15);
                    _scrollController.animateTo(
                      position,
                      duration: defaultDuration,
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                items: widget.product.images.map((image) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.network(
                        image.url,
                        fit: BoxFit.contain,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.product.images.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            ))
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
        _carouselController.jumpToPage(
          index,
        );
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.product.images[index].url),
      ),
    );
  }
}
