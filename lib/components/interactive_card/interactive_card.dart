import 'package:Wishy/components/interactive_card/invite_card.dart';
import 'package:Wishy/components/interactive_card/processing_animation.dart';
import 'package:Wishy/components/interactive_card/question_card.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/models/utils.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

enum CardTypes { question, invite, newVersion }

class InteractiveCard extends StatefulWidget {
  final InteractiveCardData interactiveCardData;
  final Function(String?, String?) closeCard;
  final bool triggerByServer;

  InteractiveCard({
    Key? key,
    required this.interactiveCardData,
    required this.closeCard,
    required this.triggerByServer,
  }) : super(key: key);

  @override
  _InteractiveCardState createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  String? _message = null;
  bool? _refetchProducts = null;
  int? _userCardId = null;
  final displayAt = DateTime.now();

  _closeCard(dynamic response, String message) async {
    setState(() {
      _message = message;
    });

    final result = await graphQLQueryHandler("interactiveCardHandler", {
      "id": _userCardId,
      "response": response,
      "card_id": widget.interactiveCardData.id,
      "displayed_at": displayAt,
      "type": widget.interactiveCardData.type.name,
    });

    if (mounted)
      setState(() {
        _message = result["message"];
        _refetchProducts = result["cursor"] != null;
      });

    if (_refetchProducts != true && result["message"] != null) {
      Future.delayed(Duration(seconds: 2), () {
        widget.closeCard(result["cursor"], result["connect_user"]);
      });
    } else {
      widget.closeCard(result["cursor"], result["connect_user"]);
    }
  }

  _sendInteractiveCardDisplayed() async {
    final result = await graphQLQueryHandler("saveUserCard", {
      "type": widget.interactiveCardData.type.name,
      "user_id": GlobalManager().userId,
      "card_id": widget.interactiveCardData.id,
      "displayed_at": displayAt,
      "session": GlobalManager().session,
      "trigger_by_server": widget.triggerByServer,
    });

    if (mounted)
      setState(() {
        _userCardId = result["id"];
      });
  }

  @override
  void initState() {
    if (widget.triggerByServer) _sendInteractiveCardDisplayed();

    super.initState();
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
                        child: getCustomCard(widget.interactiveCardData.type,
                            widget.interactiveCardData.additionalData)))));
  }

  Widget getCustomCard(CardTypes cardType, Map<String, dynamic> data) {
    switch (cardType) {
      case CardTypes.question:
        return QuestionCard(
          question: widget.interactiveCardData.question,
          hintOptions: convertValue<List<String>>(data, "hint_options", true),
          CTA: data["CTA"],
          priceRanges: convertValue<List<Map<String, String>>>(
              data, "price_ranges", true),
          withBudget: convertValue<bool>(data, "with_budget", true),
          onSelect: _closeCard,
        );
      case CardTypes.invite:
        return InviteCard(
          question: widget.interactiveCardData.question,
          onSelect: _closeCard,
          CTA: data["CTA"],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
