import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "Welcome",
              style: TextStyle(
                color: Colors.black,
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Sign in to your Wishy profile",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
            SignForm(),
            SizedBox(height: SizeConfig.screenHeight * 0.08),
          ],
        ),
      ),
    );
  }
}
