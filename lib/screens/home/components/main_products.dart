import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/interactive_card/interactive_card.dart';
import 'package:Wishy/components/interactive_card/animated_interactive_card.dart';
import 'package:Wishy/components/request_modal.dart';
import 'package:Wishy/components/swipeable_card.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/product_card.dart';
import 'package:Wishy/components/swipeable_products.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';
import 'dart:math';

class MainProducts extends StatefulWidget {
  final void Function(InteractiveCardData? card) setInteractiveCard;
  final InteractiveCardData? interactiveCard;

  MainProducts(
      {Key? key,
      required this.interactiveCard,
      required this.setInteractiveCard})
      : super(key: key);

  @override
  _MainProductsState createState() => _MainProductsState();
}

class _MainProductsState extends State<MainProducts> {
  final situation = "main_product_card";
  late GraphQLPaginationService _paginationService;
  int _productNumber = 0;
  bool _isInteractiveClose = true;
  Key _swipeableProductsKey = UniqueKey();

  void _initializePaginationService(String? cursor) {
    _paginationService = new GraphQLPaginationService(
      cursor: cursor,
      queryName: "getProductsFeed",
      variables: {"limit": 5, "tag_id": null},
      infiniteScroll: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initializePaginationService(null);
  }

  void _onSwipeUp(Product product) {
    _productNumber++;

    showRequestModal(
        context, product.id, product.title, product.variants ?? [], situation);
  }

  Future<List<Product>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final result = await _paginationService.run();
    final formattedResult =
        result["data"] != null ? formatResponse(result["data"]) : null;

    if (GlobalManager().isDeliveryAvailable == null &&
        GlobalManager().userLocation != null) {
      await DeliveryAvailabilityDialog.show(context);
    }
    if (mounted)
      setState(() {
        _isInteractiveClose = true;
      });

    return formattedResult;
  }

  Future<bool> saveLike(
      int productId, bool isLike, BuildContext context) async {
    _productNumber++;
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
  void didUpdateWidget(covariant MainProducts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.interactiveCard != oldWidget.interactiveCard) {
      setState(() {
        _isInteractiveClose = widget.interactiveCard == null;
      });
    }
  }

  void _onCloseInteractiveCard(String? cursor) {
    setState(() {
      _isInteractiveClose = cursor == null;
    });

    if (_isInteractiveClose) return;

// TODO add the cursor and fix to correct id
    _initializePaginationService(null);
    setState(() {
      _swipeableProductsKey = ValueKey<int?>(Random().nextInt(1000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: SizeConfig.screenHeight,
        child: Stack(children: [
          SwipeableProducts(
            key: _swipeableProductsKey,
            situation: situation,
            onSwipeRight: (int id) => saveLike(id, true, context),
            onSwipeLeft: (int id) => saveLike(id, false, context),
            onSwipeUp: _onSwipeUp,
            nextPage: fetchData,
            showAnimation: true,
            cardBuilder: (context, product, isInFront) {
              return ProductCard(
                  situation: situation,
                  product: product,
                  isFullScreen: true,
                  isInFront: isInFront);
            },
          ),
          if (widget.interactiveCard != null)
            AnimatedSwipeableCardWrapper(
                close: this._isInteractiveClose,
                closeHandler: () => widget.setInteractiveCard(null),
                type: widget.interactiveCard!.type,
                child: SwipeableCard(
                  key: ValueKey(widget.interactiveCard?.id),
                  items: [widget.interactiveCard!],
                  onSwipeRight: () => widget.setInteractiveCard(null),
                  onSwipeLeft: () => widget.setInteractiveCard(null),
                  cardBuilder: (context, item) {
                    return InteractiveCard(
                        interactiveCardData: item,
                        closeCard: _onCloseInteractiveCard);
                  },
                )),
        ]));
  }
}
