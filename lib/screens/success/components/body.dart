import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isCurrentPageActive = true;

  void onPress() {
    if (_isCurrentPageActive) {
      _isCurrentPageActive = false;
      Navigator.pushNamed(context, HomeScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      onPress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenWidth(30)),
            Expanded(
                child: Image.asset(
              "assets/images/success.png",
              height: getProportionateScreenWidth(300), // 40%
            )),
            SizedBox(height: getProportionateScreenHeight(60)),
            Text(
              "Login Success",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: DefaultButton(
                text: "Go to home",
                press: onPress,
              ),
            ),
            Spacer(),
          ],
        ));
  }
}
