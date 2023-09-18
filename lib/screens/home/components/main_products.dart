import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/components/swipeable_products.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/graphql_service.dart';
import '../../../size_config.dart';

class MainProducts extends StatefulWidget {
  @override
  _MainProductsState createState() => _MainProductsState();
}

class _MainProductsState extends State<MainProducts> {
  GraphQLPaginationService _paginationService = new GraphQLPaginationService(
      queryName: "getProductsFeed",
      variables: {"limit": 5},
      infiniteScroll: true);

  void _onSwipeUp(int id) {
    // Implement your logic here
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final result = await _paginationService.run();

    return result["data"] != null ? formatResponse(result["data"]) : null;
  }

  Future<bool> saveLike(
      int productId, bool isLike, BuildContext context) async {
    try {
      await graphQLQueryHandler("saveLike", {
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
    final situation = "main_product_card";

    return Container(
      height: SizeConfig.screenHeight,
      child: SwipeableProducts(
        situation: situation,
        onSwipeRight: (int id) => saveLike(id, true, context),
        onSwipeLeft: (int id) => saveLike(id, false, context),
        onSwipeUp: _onSwipeUp,
        nextPage: fetchData,
        cardBuilder: (context, product, isInFront) {
          return ProductCard(
              situation: situation,
              product: product,
              isFullScreen: true,
              isInFront: isInFront);
        },
      ),
    );
  }
}
