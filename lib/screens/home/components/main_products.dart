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
  final int limit = 5;
  final situation = "main_product_card";
  late GraphQLPaginationService _paginationService;
  bool _isInteractiveClose = true;
  Key _swipeableProductsKey = UniqueKey();
  bool _showAnimation =
      GlobalManager().showAnimation || GlobalManager().showUpAnimation;
  List<InteractiveCardData> _triggerCards = [];
  int _currentProduct = 0;
  int? _startNumber = null;
  bool _cardResult = false;
  bool _triggerByServer = false;
  bool _loadingInteractive = false;
  int? _userCardId = null;

  void _initializePaginationService(String? cursor) {
    _paginationService = new GraphQLPaginationService(
      firstCursor: cursor,
      queryName: "getProductsFeed",
      variables: {"limit": limit, "tag_id": null},
      infiniteScroll: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _initializePaginationService(GlobalManager().firstFeedCursor);

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
        context, product.id, product.title, product.variants ?? [], situation,
        cursor: _paginationService.firstCursor);
  }

  void _fetchFeedCards() async {
    if (widget.interactiveCard != null || _loadingInteractive) return;
    _loadingInteractive = true;

    if (_startNumber == null) {
      final result = await graphQLQueryHandler("countOldUserSwipes", {
        "limit": 10,
      });
      _startNumber = result["result"];
    }

    final result = await graphQLQueryHandler("getFeedInteractiveCards", {
      "start_number": _currentProduct,
      "end_number": _currentProduct + limit,
      "old_swipes": _startNumber
    });

    if (result["cards"] != null) {
      final formattedResult = (result["cards"] as List<dynamic>)
          .map((item) => new InteractiveCardData.fromJson(item))
          .toList();

      if (mounted)
        setState(() {
          _triggerCards = formattedResult;
          _loadingInteractive = false;
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
        "user_id": GlobalManager().userId,
        "cursor": _paginationService.firstCursor
      });

      return true;
    } catch (error) {
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

  void skipCard() {
    setState(() {
      _userCardId = null;
      _triggerByServer = false;
    });

    widget.setInteractiveCard(null);
  }

  void _onCloseInteractiveCard(String? cursor, String? connectUser) {
    setState(() {
      _isInteractiveClose = cursor == null;
      _cardResult = cursor != null;
      _triggerByServer = false;
      _userCardId = null;
    });
    widget.setConnectUser(connectUser);

    if (_isInteractiveClose) return;

    GlobalManager().setFirstFeedCursor(cursor);
    _initializePaginationService(cursor);

    widget.setConnectUser(connectUser);

    setState(() {
      _swipeableProductsKey = ValueKey<String?>(cursor);
    });
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

      _sendInteractiveCardDisplayed(activeCards[0]);
    }
  }

  _sendInteractiveCardDisplayed(InteractiveCardData card) async {
    final result = await graphQLQueryHandler("saveUserCard", {
      "type": card.type.name,
      "user_id": GlobalManager().userId,
      "card_id": card.id,
      "displayed_at": DateTime.now(),
      "session": GlobalManager().session,
      "trigger_by_server": true,
      "custom_trigger_id": card.customTriggerId,
    });

    if (mounted)
      setState(() {
        _userCardId = result["id"];
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
                isInFront: isInFront,
                cursor: _paginationService.firstCursor,
              );
            },
          ),
          if (widget.interactiveCard != null)
            AnimatedSwipeableCardWrapper(
                close: this._isInteractiveClose,
                closeHandler: skipCard,
                type: widget.interactiveCard!.type,
                child: SwipeableCard(
                  key: ValueKey(widget.interactiveCard?.id),
                  items: [widget.interactiveCard!],
                  onSwipeRight: skipCard,
                  onSwipeLeft: skipCard,
                  cardBuilder: (context, item) {
                    return InteractiveCard(
                        triggerByServer: _triggerByServer,
                        interactiveCardData: item,
                        currentCursor: _paginationService.firstCursor,
                        closeCard: _onCloseInteractiveCard,
                        userCardId: _userCardId,
                        connectUser: GlobalManager().connectUser);
                  },
                )),
          if (_showAnimation)
            SwipeTutorialOverlay(
                swipes: GlobalManager().showAnimation,
                up: GlobalManager().showUpAnimation,
                onFinished: () {
                  setState(() {
                    this._showAnimation = false;
                  });
                  GlobalManager().setShowAnimation(false);
                  GlobalManager().setShowUpAnimation(false);
                }),
        ]));
  }
}
