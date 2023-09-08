import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/checkout/components/buy_as_gift_form.dart';
import 'package:shop_app/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(10)),
                Text("Complete Purchase", style: headingStyle),
                SizedBox(height: getProportionateScreenHeight(20)),
                TabBar(
                  labelColor: kPrimaryColor,
                  indicatorColor: kPrimaryColor,
                  tabs: [
                    Tab(text: 'Buy for Yourself'),
                    Tab(text: 'Buy as a Gift'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      BuyForYourself(),
                      BuyAsGift(),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  "By continuing your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2, // I assume you meant `bodyText2` instead of `bodySmall`
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
