import 'package:flutter/material.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';

class RouterUtils {
  static void routeToHomePage(BuildContext context, bool? profileCompleted) {
    Navigator.pushReplacementNamed(
        context,
        profileCompleted == null || !profileCompleted
            ? CompleteProfileScreen.routeName
            : HomeScreen.routeName);
  }
}
