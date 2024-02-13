import 'package:Wishy/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/size_config.dart';
import 'package:lottie/lottie.dart';

class Purchase extends StatelessWidget {
  static int SCREEN_TIME = 5;
  static String CTA_ROUTE_NAME = HomeScreen.routeName;

  final void Function(String) onPressHandler;

  const Purchase({
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
            SizedBox(height: getProportionateScreenHeight(30)),
            Lottie.asset(
              "assets/animations/shipping.json",
              fit: BoxFit.contain,
              width: 200,
              height: 200,
              repeat: true,
            ),
            Text(
              "Your Gift is on Its Way!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text(
              "Our magic delivery truck has set off! We're as excited as you are to spread joy and surprises.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(50)),
            TextButton(
                onPressed: () => onPressHandler(ProfileScreen.routeName),
                child: Text("Track Your Gift's Journey Here")),
            SizedBox(
              width: SizeConfig.screenWidth,
              child: DefaultButton(
                text: "Back to Home",
                press: () => onPressHandler(Purchase.CTA_ROUTE_NAME),
              ),
            ),
          ],
        ));
  }
}
