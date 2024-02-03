import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
    required this.onImageChange,
    required this.selectedImage,
    required this.scrollController,
    required this.carouselController,
  }) : super(key: key);

  final Product product;
  final int selectedImage;
  final Function(int) onImageChange;
  final ScrollController scrollController;
  final CarouselController carouselController;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  final situation = "product_details";

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
                carouselController: widget.carouselController,
                options: CarouselOptions(
                  height: double.infinity,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    widget.onImageChange(index);
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
            controller: widget.scrollController,
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
        widget.onImageChange(index);
        widget.carouselController.jumpToPage(
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
              color: kPrimaryColor
                  .withOpacity(widget.selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.product.images[index].url),
      ),
    );
  }
}
