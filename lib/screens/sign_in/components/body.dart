import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: getProportionateScreenWidth(65),
              backgroundImage: AssetImage('assets/images/android_icon.png'),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            Text(
              "Welcome to Wishy",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(28),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              GlobalManager().signInRelatedProductId == null
                  ? "Unlock the magic of gifting! Sign up to curate your wishlist and surprise friends with the perfect gifts."
                  : "Please add your phone number to finalize your action",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            SignForm(),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    ));
  }
}
