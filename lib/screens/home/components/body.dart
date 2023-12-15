import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/screens/home/components/home_header.dart';
import 'package:Wishy/screens/home/components/main_products.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late InteractiveCardData? _interactiveCard = null;

  void _setInteractiveCard(InteractiveCardData? value) {
    setState(() {
      _interactiveCard = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          HomeHeader(
            height: 60,
            setInteractiveCard: _setInteractiveCard,
            interactiveCard: _interactiveCard,
          ),
          Expanded(
            child: MainProducts(
              setInteractiveCard: _setInteractiveCard,
              interactiveCard: _interactiveCard,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
