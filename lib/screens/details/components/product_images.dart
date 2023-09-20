import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:Wishy/utils/analytics.dart';

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
  final situation = "product_details";
  CarouselController _carouselController = CarouselController();
  ScrollController _scrollController = ScrollController();
  int selectedImage = 0;

  void _sendImageViewedEvent() {
    AnalyticsService.trackEvent(analyticEvents["PRODUCT_IMAGE_VIEWED"]!,
        properties: {
          'Product Id': widget.product.id,
          'Product Title': widget.product.title,
          'Image Url': widget.product.images.isNotEmpty
              ? widget.product.images[selectedImage].url
              : null,
          "Situation": situation
        });
  }

  @override
  void initState() {
    super.initState();

    _sendImageViewedEvent();
  }

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
                    _sendImageViewedEvent();
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
        _sendImageViewedEvent();
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
