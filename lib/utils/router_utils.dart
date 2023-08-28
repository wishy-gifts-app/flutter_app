import 'package:flutter/material.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';

class RouterUtils {
  static void routeToHomePage(BuildContext context, bool? profileCompleted) {
    Navigator.pushReplacementNamed(
        context,
        profileCompleted == null || !profileCompleted
            ? CompleteProfileScreen.routeName
            : HomeScreen.routeName);
  }
}
