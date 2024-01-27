import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/checkout/components/custom_app_bar.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';

import 'components/body.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  final Variant variant;
  final Product product;
  final int? recipientId;
  final String? cursor;

  CheckoutScreen(
      {required this.variant,
      required this.product,
      this.recipientId,
      this.cursor = null});

  void _redirectToSignInIfNeeded(BuildContext context) {
    if (!GlobalManager().signedIn) {
      GlobalManager().setSignInRelatedProductId(product.id);
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else if (GlobalManager().profileCompleted != true) {
      GlobalManager().setSignInRelatedProductId(product.id);
      Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _redirectToSignInIfNeeded(context);
    });

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(),
      ),
      body: Body(
        variant: variant,
        product: product,
        recipientId: recipientId,
      ),
    );
  }
}
