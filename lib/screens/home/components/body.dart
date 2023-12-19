import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/InteractiveCardData.dart';
import 'package:Wishy/screens/home/components/custom_progress_bar.dart';
import 'package:Wishy/screens/home/components/home_header.dart';
import 'package:Wishy/screens/home/components/main_products.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int _currentProductNumber = 0;
  UniqueKey _homeKey = UniqueKey();
  String? _connectUser = null;

  void setConnectUser(String? value) {
    setState(() {
      _connectUser = value;
    });

    GlobalManager().setConnectUser(value);
  }

  void nextProductCounter() {
    this.setState(() {
      _currentProductNumber = _currentProductNumber + 1;
    });
  }

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
            key: _homeKey,
            height: 50,
            setInteractiveCard: _setInteractiveCard,
            interactiveCard: _interactiveCard,
            connectUser: _connectUser,
          ),
          StepProgressBar(
            currentSessionCount: _currentProductNumber,
            width: 250,
            height: 45,
          ),
          Expanded(
            child: MainProducts(
              nextProductCounter: nextProductCounter,
              setInteractiveCard: _setInteractiveCard,
              interactiveCard: _interactiveCard,
              setConnectUser: setConnectUser,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
