import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/swipeable_products.dart';

class PopularProducts extends StatelessWidget {
  final double height;
  Map<String, dynamic>? _paginationServices;
  List<Product> popularProducts = [];

  PopularProducts({Key? key, this.height = 150.0})
      : super(key: key); // Default value set to 150

  Future<dynamic> _initializeData() async {
    _paginationServices = await GraphQLService()
        .queryHandler("getProductsFeed", {"limit": 5}, withPagination: true);
    return _paginationServices!["data"];
  }

  void _onSwipeRight(String id) {
    // Implement your logic here
  }

  void _onSwipeLeft(String id) {
    // Implement your logic here
  }

  void _onSwipeUp(String id) {
    // Implement your logic here
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();
    if (_paginationServices == null) {
      final result = await _initializeData();
      return formatResponse(result);
    } else {
      final nextPageData = await _paginationServices!["nextPage"]();
      return nextPageData != null
          ? formatResponse(nextPageData['products'])
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Container(
        height: SizeConfig.screenHeight - height,
        child: SwipeableCardWidget(
          onSwipeRight: _onSwipeRight,
          onSwipeLeft: _onSwipeLeft,
          onSwipeUp: _onSwipeUp,
          nextPage: fetchData,
        ),
      ),
    );
  }
}
