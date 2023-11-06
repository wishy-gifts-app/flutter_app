import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/request_modal.dart';
import 'package:Wishy/models/Tag.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/product_card.dart';
import 'package:Wishy/components/swipeable_products.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';

class MainProducts extends StatefulWidget {
  final Tag? selectedTag;

  MainProducts({Key? key, this.selectedTag}) : super(key: key);

  @override
  _MainProductsState createState() => _MainProductsState();
}

class _MainProductsState extends State<MainProducts> {
  late GraphQLPaginationService _paginationService;

  void _initializePaginationService() {
    print(widget.selectedTag?.id);
    _paginationService = new GraphQLPaginationService(
      queryName: "getProductsFeed",
      variables: {"limit": 5, "tag_id": widget.selectedTag?.id},
      infiniteScroll: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initializePaginationService();
  }

  void _onSwipeUp(Product product) {
    showRequestModal(
        context, product.id, product.title, product.variants ?? []);
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final result = await _paginationService.run();
    final formattedResult =
        result["data"] != null ? formatResponse(result["data"]) : null;

    if (formattedResult != null &&
        GlobalManager().isDeliveryAvailable == null) {
      if (formattedResult[0].isAvailable) {
        GlobalManager().setDeliveryAvailability(true);
      } else {
        await DeliveryAvailabilityDialog.show(context);
      }
    }

    return formattedResult;
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
