import 'package:Wishy/components/interactive_card/invite_card.dart';
import 'package:Wishy/components/interactive_card/message_card.dart';
import 'package:Wishy/components/interactive_card/processing_animation.dart';
import 'package:Wishy/components/interactive_card/question_card.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/models/utils.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';

enum CardTypes { question, invite, message, newVersion }

class InteractiveCard extends StatefulWidget {
  final InteractiveCardData interactiveCardData;
  final Function(String?, String?, int?) closeCard;
  final bool triggerByServer;
  final String? currentCursor;
  final int? userCardId;
  final String? connectUser;

  InteractiveCard({
    Key? key,
    required this.interactiveCardData,
    required this.closeCard,
    required this.triggerByServer,
    required this.currentCursor,
    this.userCardId,
    this.connectUser,
  }) : super(key: key);

  @override
  _InteractiveCardState createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  String? _message = null;
  bool? _refetchProducts = null;
  final displayAt = DateTime.now();

  _onSelect(dynamic response, String message) async {
    AnalyticsService.trackEvent(analyticEvents["INTERACTIVE_CARD_HANDLED"]!,
        properties: {
          "Id": widget.userCardId,
          "Response": response,
          "Card Id": widget.interactiveCardData.id,
          "Type": widget.interactiveCardData.type.name,
          "Custom Trigger Id": widget.interactiveCardData.customTriggerId,
          "Trigger By Server": widget.triggerByServer
        });
    if (mounted)
      setState(() {
        _message = message;
      });

    graphQLQueryHandler("interactiveCardHandler", {
      "id": widget.userCardId,
      "response": response,
      "card_id": widget.interactiveCardData.id,
      "displayed_at": displayAt,
      "type": widget.interactiveCardData.type.name,
      "current_cursor": widget.currentCursor,
      "custom_trigger_id": widget.interactiveCardData.customTriggerId,
    }).then((result) {
      if (mounted)
        setState(() {
          _message = result["message"];
          _refetchProducts = result["cursor"] != null;
        });

      if (_refetchProducts != true && result?["message"] != null) {
        Future.delayed(Duration(seconds: 2), () {
          widget.closeCard(result["cursor"], result["connect_user"],
              result?["connect_user_id"]);
        });
      } else {
        widget.closeCard(result?["cursor"], result?["connect_user"],
            result?["connect_user_id"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          image: widget.interactiveCardData.backgroundImagePath
                  .startsWith('assets')
              ? DecorationImage(
                  image: AssetImage(
                      widget.interactiveCardData.backgroundImagePath),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: NetworkImage(
                      widget.interactiveCardData.backgroundImagePath),
                  fit: BoxFit.cover,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
            child: _message != null
                ? ProcessingAnimationWidget(
                    message: _message!,
                    refetchProducts: _refetchProducts == true)
                : SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: getCustomCard(
                            widget.interactiveCardData.type,
                            widget.interactiveCardData.additionalData,
                            widget.interactiveCardData.customData)))));
  }

  Widget getCustomCard(CardTypes cardType, Map<String, dynamic> data,
      Map<String, dynamic> customData) {
    switch (cardType) {
      case CardTypes.question:
        return QuestionCard(
          question: widget.interactiveCardData.question,
          hintOptions: convertValue<List<String>>(data, "hint_options", true),
          CTA: data["CTA"],
          priceRanges: convertValue<List<Map<String, String>>>(
              data, "price_ranges", true),
          withBudget: convertValue<bool>(data, "with_budget", true),
          onSelect: _onSelect,
        );
      case CardTypes.invite:
        return InviteCard(
            question: widget.interactiveCardData.question,
            onSelect: _onSelect,
            CTA: data["CTA"],
            connectUser: widget.connectUser,
            suggestUser: customData["suggest_user"] != null
                ? Follower.fromJson(customData["suggest_user"])
                : null);
      case CardTypes.message:
        return MessageCard(
          question: widget.interactiveCardData.question,
          CTA: data["CTA"],
          closeCard: widget.closeCard,
          onSelect: _onSelect,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
