import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/size_config.dart';
import 'package:lottie/lottie.dart';

class Login extends StatelessWidget {
  static int SCREEN_TIME = 2;
  static String CTA_ROUTE_NAME = HomeScreen.routeName;

  final void Function(String) onPressHandler;

  const Login({
    Key? key,
    required this.onPressHandler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(50)),

            Lottie.asset(
              "assets/animations/success.json",
              fit: BoxFit.contain,
              width: 200,
              height: 200,
              repeat: true,
            ),
            Text(
              "Login Success",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(200)),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: DefaultButton(
                text: "Go to home",
                press: () => onPressHandler(Login.CTA_ROUTE_NAME),
              ),
            ),
            // Spacer(),
          ],
        ));
  }
}
