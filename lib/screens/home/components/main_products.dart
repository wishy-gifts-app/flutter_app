import 'dart:async';
import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/interactive_card/interactive_card.dart';
import 'package:Wishy/components/interactive_card/animated_interactive_card.dart';
import 'package:Wishy/components/request_modal.dart';
import 'package:Wishy/components/swipe_tutorial_overlay.dart';
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
  final Function nextProductCounter;
  final Function(String?) setConnectUser;

  MainProducts({
    Key? key,
    required this.interactiveCard,
    required this.setInteractiveCard,
    required this.nextProductCounter,
    required this.setConnectUser,
  }) : super(key: key);

  @override
  _MainProductsState createState() => _MainProductsState();
}

class _MainProductsState extends State<MainProducts> {
  final situation = "main_product_card";
  late GraphQLPaginationService _paginationService;
  bool _isInteractiveClose = true;
  Key _swipeableProductsKey = UniqueKey();
  bool _showAnimation = GlobalManager().showAnimation;
  List<InteractiveCardData> _triggerCards = [];
  int _currentProduct = 0;
  int? _startNumber = null;
  bool _cardResult = false;
  bool _triggerByServer = false;

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

    Future.delayed(
        Duration(seconds: 6), () => _showAvailabilityDialogIfNeeded());
  }

  void _showAvailabilityDialogIfNeeded() {
    if (GlobalManager().isDeliveryAvailable == null &&
        GlobalManager().userLocation != null &&
        !this._showAnimation) {
      DeliveryAvailabilityDialog.show(context);
    }
  }

  void _onSwipeUp(Product product) {
    _nextProduct();

    showRequestModal(
        context, product.id, product.title, product.variants ?? [], situation);
  }

  void _fetchFeedCards() async {
    if (_startNumber == null) {
      final result = await graphQLQueryHandler("countOldUserSwipes", {
        "limit": 10,
      });
      setState(() {
        _startNumber = result["result"];
      });
    }
    final result = await graphQLQueryHandler("getFeedInteractiveCards", {
      "start_number": _currentProduct,
      "end_number": _currentProduct + 5,
      "old_swipes": _startNumber
    });

    if (result["cards"] != null) {
      final formattedResult = (result["cards"] as List<dynamic>)
          .map((item) => new InteractiveCardData.fromJson(item))
          .toList();

      if (mounted)
        setState(() {
          _triggerCards = formattedResult;
        });

      triggerCard();
    }
  }

  Future<List<Product>?> fetchData() async {
    if (!_cardResult) _fetchFeedCards();

    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Product.fromJson(item))
        .toList();

    final result = await _paginationService.run();
    final formattedResult =
        result["data"] != null ? formatResponse(result["data"]) : null;

    if (mounted && _cardResult)
      setState(() {
        _isInteractiveClose = true;
        _cardResult = false;
      });

    return formattedResult;
  }

  Future<bool> saveLike(
      int productId, bool isLike, BuildContext context) async {
    _nextProduct();
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

  void _onCloseInteractiveCard(String? cursor, String? connectUser) {
    setState(() {
      _isInteractiveClose = cursor == null;
      _cardResult = cursor != null;
      _triggerByServer = false;
    });
    widget.setConnectUser(connectUser);

    if (_isInteractiveClose) return;

    _initializePaginationService(cursor);
    setState(() {
      _swipeableProductsKey = ValueKey<int?>(Random().nextInt(1000));
    });

    widget.setConnectUser(connectUser);
  }

  void _nextProduct() {
    widget.nextProductCounter();
    setState(() {
      _currentProduct++;
    });

    triggerCard();
  }

  void triggerCard() {
    List<InteractiveCardData> activeCards = this
        ._triggerCards
        .where(
            (element) => element.productsCountTrigger! <= this._currentProduct)
        .toList();

    if (activeCards.length > 0) {
      widget.setInteractiveCard(activeCards[0]);

      setState(() {
        _triggerCards.remove(activeCards[0]);
        _triggerByServer = true;
      });
    }
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
                        triggerByServer: _triggerByServer,
                        interactiveCardData: item,
                        closeCard: _onCloseInteractiveCard);
                  },
                )),
          if (_showAnimation)
            SwipeTutorialOverlay(
                right: true,
                left: true,
                onFinished: () {
                  setState(() {
                    this._showAnimation = false;
                  });
                  GlobalManager().setShowAnimation(false);
                }),
        ]));
  }
}
