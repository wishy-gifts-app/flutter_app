import 'package:flutter/material.dart';
import 'package:Wishy/components/swipe_left_card.dart';
import 'package:Wishy/components/swipeable_products.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:Wishy/components/product_card.dart';

class LikesProducts extends StatefulWidget {
  final bool isLike;

  LikesProducts({
    required this.isLike,
  });

  @override
  _LikesProductsState createState() => _LikesProductsState();
}

class _LikesProductsState extends State<LikesProducts> {
  late GraphQLPaginationService _paginationServices;

  void initState() {
    _paginationServices = new GraphQLPaginationService(
        queryName: "getLikedProducts",
        variables: {"limit": 6, "is_like": widget.isLike});
    super.initState();
  }

  void _onSwipeUp(int id) {
    // Implement your logic here
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final nextPageData = await _paginationServices.run();
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
    final String situation =
        widget.isLike ? "like_product_card" : "unlike_product_card";

    return Container(
        height: SizeConfig.screenHeight,
        child: new SwipeableLeftProducts(
          situation: situation,
          emptyString:
              "You don't have ${widget.isLike ? "liked" : "unliked"} products yet, start to swiping",
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
