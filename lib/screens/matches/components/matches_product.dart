import 'package:flutter/material.dart';
import 'package:Wishy/components/swipe_left_card.dart';
import 'package:Wishy/components/swipeable_products.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:Wishy/components/product_card.dart';

class MatchesProducts extends StatefulWidget {
  @override
  _MatchesProductsState createState() => _MatchesProductsState();
}

class _MatchesProductsState extends State<MatchesProducts> {
  GraphQLPaginationService _paginationService = new GraphQLPaginationService(
      queryName: "getMatchedProducts", variables: {"limit": 5});

  void initState() {
    super.initState();
  }

  void _onSwipeUp(int id) {
    // Implement your logic here
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final nextPageData = await _paginationService.run();
    return nextPageData["data"] != null
        ? formatResponse(nextPageData["data"])
        : null;
  }

  Future<bool> saveLike(
    int productId,
    bool isLike,
    BuildContext context,
  ) async {
    try {
      graphQLQueryHandler("saveLike", {
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
    final situation = "match_product_card";

    return Container(
        height: SizeConfig.screenHeight,
        child: new SwipeableLeftProducts(
          situation: situation,
          emptyString: "You don't have matches yet",
          onSwipeRight: (int id) => saveLike(id, true, context),
          onSwipeLeft: (int id) => saveLike(id, false, context),
          onSwipeUp: _onSwipeUp,
          nextPage: fetchData,
          cardBuilder: (context, product) {
            return ProductCard(
              situation: situation,
              product: product,
              isFullScreen: false,
            );
          },
        ));
  }
}
