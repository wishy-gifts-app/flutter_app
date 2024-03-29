import 'dart:async';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class MessageCard extends StatefulWidget {
  static bool sent = false;

  final String CTA;
  final String question;
  final Function(String?, String?, int?) closeCard;
  final Function(Map<String, dynamic>, String) onSelect;

  MessageCard({
    Key? key,
    required this.CTA,
    required this.question,
    required this.closeCard,
    required this.onSelect,
  }) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  void _sendRequest() {
    if (!MessageCard.sent) {
      MessageCard.sent = true;

      widget.onSelect(new Map(), "");
      widget.closeCard(null, null, null);
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      _sendRequest();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedBackgroundText(
          widget.question,
          backgroundColor: Colors.white.withOpacity(0.8),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Muli",
            color: kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            wordSpacing: 1,
            height: 1.2,
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.8),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(50)),
        DefaultButton(
          press: () => widget.closeCard(null, null, null),
          text: widget.CTA,
        ),
      ],
    );
  }
}
