import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/components/swipeable_products.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/swipeable_card.dart';

class PopularProducts extends StatelessWidget {
  final double height;
  Map<String, dynamic>? _paginationServices;

  PopularProducts({Key? key, this.height = 150.0})
      : super(key: key); // Default value set to 150

  Future<dynamic> _initializeData() async {
    _paginationServices = await GraphQLService()
        .queryHandler("getProductsFeed", {"limit": 5}, withPagination: true);
    final result = await _paginationServices!["nextPage"]();

    return result;
  }

  void _onSwipeUp(int id) {
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
      return nextPageData != null ? formatResponse(nextPageData) : null;
    }
  }

  Future<bool> saveLike(
      int productId, bool isLike, BuildContext context) async {
    try {
      await GraphQLService().queryHandler("saveLike", {
        "product_id": productId,
        "is_like": isLike,
        "user_id": GlobalManager().userId
      });

      return true;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error to save reaction. Please try again.')),
      );

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      child: SwipeableProducts(
        onSwipeRight: (int id) => saveLike(id, false, context),
        onSwipeLeft: (int id) => saveLike(id, false, context),
        onSwipeUp: _onSwipeUp,
        nextPage: fetchData,
        cardBuilder: (context, product) {
          return ProductCard(
              product: product,
              isFullScreen:
                  true); // Replace CustomCard with your desired card widget
        },
      ),
    );
  }
}
