import 'package:Wishy/models/Match.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/swipe_left_card.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/services/graphql_service.dart';
import '../../../size_config.dart';
import 'package:Wishy/components/product_card.dart';

class MatchesProducts extends StatefulWidget {
  @override
  _MatchesProductsState createState() => _MatchesProductsState();
}

class _MatchesProductsState extends State<MatchesProducts> {
  final situation = "match_product_card";

  GraphQLPaginationService _paginationService = new GraphQLPaginationService(
      queryName: "getMatchedProducts", variables: {"limit": 5});

  void initState() {
    super.initState();
  }

  Future<List<Match>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => new Match.fromJson(item))
        .toList();

    final nextPageData = await _paginationService.run();

    final formattedResult = nextPageData["data"] != null
        ? formatResponse(nextPageData["data"])
        : null;

    if (formattedResult != null) {
      final newMatches =
          formattedResult.where((newMatch) => newMatch.displayedAt == null);

      for (var match in newMatches) {
        graphQLQueryHandler(
          "updateMatchById",
          {
            "id": match.id,
            "displayed_at": DateTime.now(),
          },
        );
      }
    }

    return formattedResult;
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
    return Container(
        height: SizeConfig.screenHeight,
        child: new SwipeableLeftProducts<Match>(
          situation: situation,
          emptyCTA: "Find Friends' Wishes",
          emptyTitle: "Discover Shared Wishes",
          emptyString:
              "Your circle of surprises is just a swipe away. Connect and uncover the wishes you and your friends have in common!",
          onSwipeLeft: (int id) => saveLike(id, false, context),
          nextPage: fetchData,
          cardBuilder: (context, item) {
            return ProductCard(
              situation: situation,
              product: item.product,
              isFullScreen: false,
            );
          },
        ));
  }
}
