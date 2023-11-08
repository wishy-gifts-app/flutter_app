import 'package:Wishy/screens/checkout/components/purchase_form.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/components/buy_as_gift_form.dart';
import 'package:Wishy/screens/checkout/components/buy_for_yourself_form.dart';
import 'package:Wishy/size_config.dart';

class Body extends StatelessWidget {
  final Variant variant;
  final int productId;

  Body({required this.variant, required this.productId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
            //  DefaultTabController(
            //   length: 2,
            //   child: SizedBox(
            //     width: double.infinity,
            //     child:
            SingleChildScrollView(
                child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          Text("Complete Purchase", style: headingStyle),
          SizedBox(height: getProportionateScreenHeight(20)),
          PurchaseForm(
            variantId: variant.id,
          ),

          // TabBar(
          //   labelColor: kPrimaryColor,
          //   indicatorColor: kPrimaryColor,
          //   tabs: [
          //     Tab(text: 'Buy for Yourself'),
          //     Tab(text: 'Buy as a Gift'),
          //   ],
          // ),
          // Expanded(
          //   child: TabBarView(
          //     children: [
          //       BuyForYourself(
          //         variantId: variant.id,
          //       ),
          //       BuyAsGift(variantId: variant.id),
          //     ],
          //   ),
          // ),
        ],
      ),
    ))
        //   ),
        // ),
        // ),
        );
  }
}
