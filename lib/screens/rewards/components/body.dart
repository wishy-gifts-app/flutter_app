import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  final double headerHeight = 40.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      Align(
          alignment: Alignment.center,
          child: Image.asset("assets/images/reward_page.png")),
      Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: DefaultButton(
                press: () =>
                    Navigator.of(context).pushNamed(HomeScreen.routeName),
                text: "Start Shopping",
              )))
    ]));
  }
}
