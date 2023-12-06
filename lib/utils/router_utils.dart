import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';

class RouterUtils {
  static void _routeHandler(BuildContext context, String? token) {
    if (token == null || token.isEmpty) {
      GlobalManager().setShowAnimation(token == null || token.isEmpty);
      // create user with some uniq id
    }

    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  static void routeToHomePage(
      BuildContext context, bool? signedIn, String? token) {
    if (token == null || token.isEmpty) {
      GlobalManager().setShowAnimation(token == null || token.isEmpty);
      // create user with some uniq id
    }

    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  static void routeToRequestsPage(BuildContext context, String? token) {
    if (token == null || token.isEmpty) {
      GlobalManager().setShowAnimation(token == null || token.isEmpty);
      // create user with some uniq id
    }

    Navigator.pushReplacementNamed(context, RequestsScreen.routeName);
  }
}
