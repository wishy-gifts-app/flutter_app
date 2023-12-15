import 'package:Wishy/components/interactive_card/interactive_card.dart';
import 'package:Wishy/components/support.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/models/Tag.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class HomeHeader extends StatefulWidget {
  final double? height;
  final void Function(InteractiveCardData? card) setInteractiveCard;
  final InteractiveCardData? interactiveCard;

  const HomeHeader({
    Key? key,
    this.height,
    required this.setInteractiveCard,
    required this.interactiveCard,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late InteractiveCardData _inviteCard;
  late InteractiveCardData _questionCard;

  void _fetchInteractiveCardsData() async {
    try {
      final _inviteCardResult = await graphQLQueryHandler(
          "getInteractiveCardByType", {"type": CardTypes.invite.name});
      final _questionCardResult = await graphQLQueryHandler(
          "getInteractiveCardByType", {"type": CardTypes.question.name});
      if (mounted) {
        _questionCard = InteractiveCardData.fromJson(_questionCardResult);
        _inviteCard = InteractiveCardData.fromJson(_inviteCardResult);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    _fetchInteractiveCardsData();
    super.initState();
  }

  void _setInteractiveDialog(CardTypes type) {
    switch (type) {
      case CardTypes.question:
        if (widget.interactiveCard?.type == CardTypes.question)
          widget.setInteractiveCard(null);
        else
          widget.setInteractiveCard(_questionCard);
        break;
      case CardTypes.invite:
        if (widget.interactiveCard?.type == CardTypes.invite)
          widget.setInteractiveCard(null);
        else
          widget.setInteractiveCard(_inviteCard);
        break;
      default:
        widget.setInteractiveCard(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () => _setInteractiveDialog(CardTypes.invite),
                  ),
                ]),
            Text(
              "Wishy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () => _setInteractiveDialog(CardTypes.question),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatelessWidget {
  final List<Tag> tags;
  final ValueChanged<Tag?> onTagSelected;

  FilterDialog({
    required this.tags,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
                ListTile(
                  title: Text('All Products'),
                  onTap: () => onTagSelected(null),
                ),
                Divider(),
              ] +
              tags.map((Tag tag) {
                return ListTile(
                  title: Text(tag.value),
                  onTap: () => onTagSelected(tag),
                );
              }).toList(),
        ),
      ),
    );
  }
}
