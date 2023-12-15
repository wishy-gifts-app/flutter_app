import 'package:Wishy/components/interactive_card/invite_card.dart';
import 'package:Wishy/components/interactive_card/processing_animation.dart';
import 'package:Wishy/components/interactive_card/question_card.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/models/utils.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

enum CardTypes { question, invite }

class InteractiveCard extends StatefulWidget {
  final InteractiveCardData interactiveCardData;
  final Function(String?) closeCard;

  InteractiveCard({
    Key? key,
    required this.interactiveCardData,
    required this.closeCard,
  }) : super(key: key);

  @override
  _InteractiveCardState createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  String? _message = null;
  bool? _refetchProducts = null;

  _closeCard(dynamic v, String message) {
    setState(() {
      _message = message;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (mounted)
        setState(() {
          _message = "Curating Your Perfect Match...";
          _refetchProducts = true;
        });

      widget.closeCard("null");
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedBackgroundText(
                          widget.interactiveCardData.question,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            wordSpacing: 1,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        getCustomCard(widget.interactiveCardData.type,
                            widget.interactiveCardData.additionalData)
                      ],
                    ),
                  ))));
  }

  Widget getCustomCard(CardTypes cardType, Map<String, dynamic> data) {
    switch (cardType) {
      case CardTypes.question:
        return QuestionCard(
          hintOptions: convertValue<List<String>>(data, "hint_options", true),
          CTA: data["CTA"],
          priceRanges: convertValue<List<Map<String, String>>>(
              data, "price_ranges", true),
          withBudget: convertValue<bool>(data, "with_budget", true),
          onSelect: _closeCard,
        );
      case CardTypes.invite:
        return InviteCard(
          onSelect: _closeCard,
          CTA: data["CTA"],
        );
      default:
        return SizedBox.shrink();
    }
  }
}
