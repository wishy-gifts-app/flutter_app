import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isCurrentPageActive = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (_isCurrentPageActive) {
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
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
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: DefaultButton(
                text: "Go to home",
                press: () {
                  _isCurrentPageActive = false;
                  Navigator.pushNamed(context, HomeScreen.routeName);
                },
              ),
            ),
            Spacer(),
          ],
        ));
  }
}
