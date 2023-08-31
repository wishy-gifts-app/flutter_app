import 'package:flutter/material.dart';
import 'package:shop_app/components/swipeable_products.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/product_card.dart';

class LikesProducts extends StatefulWidget {
  final bool isLike;

  LikesProducts({
    required this.isLike,
  });

  @override
  _LikesProductsState createState() => _LikesProductsState();
}

class _LikesProductsState extends State<LikesProducts> {
  Map<String, dynamic>? _paginationServices;

  Future<void> _initializeData() async {
    final result = await GraphQLService().queryHandler(
        "getLikedProducts", {"limit": 5, "is_like": widget.isLike},
        withPagination: true);

    if (mounted) {
      print(result);
      setState(() {
        _paginationServices = result;
      });
      print(_paginationServices);
    }
  }

  void initState() {
    _initializeData();
    super.initState();
  }

  void _onSwipeUp(int id) {
    // Implement your logic here
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final nextPageData = await _paginationServices!["nextPage"]();
    return nextPageData != null ? formatResponse(nextPageData) : null;
  }

  Future<bool> saveLike(
    int productId,
    bool isLike,
    BuildContext context,
  ) async {
    try {
      final graphQLService = new GraphQLService();
      graphQLService.queryHandler("saveLike", {
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
    if (_paginationServices == null) {
      return CircularProgressIndicator();
    }
    final String situation =
        widget.isLike ? "like_product_card" : "unlike_product_card";

    return Container(
        height: SizeConfig.screenHeight,
        child: new SwipeableProducts(
          situation: situation,
          emptyString:
              "You don't have ${widget.isLike ? "liked" : "unliked"} products yet, start to swiping",
          onSwipeRight: (int id) => saveLike(id, widget.isLike, context),
          onSwipeLeft: (int id) => saveLike(id, widget.isLike, context),
          onSwipeUp: _onSwipeUp,
          nextPage: fetchData,
          isFullPage: false,
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
