import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Product.dart';

import 'components/body.dart';

class CheckoutScreen extends StatelessWidget {
  static String routeName = "/checkout";
  final Variant variant;
  final int productId;
  final int? recipientId;
  final String? cursor;

  CheckoutScreen(
      {required this.variant,
      required this.productId,
      this.recipientId,
      this.cursor = null});

  void _redirectToSignInIfNeeded(BuildContext context) {
    if (!GlobalManager().signedIn) {
      GlobalManager().setSignInRelatedProductId(productId);
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else if (GlobalManager().profileCompleted != true) {
      GlobalManager().setSignInRelatedProductId(productId);
      Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _redirectToSignInIfNeeded(context));

    return Scaffold(
      appBar: AppBar(),
      body: Body(
        variant: variant,
        productId: productId,
        recipientId: recipientId,
      ),
    );
  }
}
