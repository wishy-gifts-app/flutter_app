import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';

class RouterUtils {
  static void routeToHomePage(BuildContext context, bool? profileCompleted,
      String? token, bool signedIn) {
    GlobalManager().setShowAnimation(token == null || token.isEmpty);

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else if ((profileCompleted == null || !profileCompleted) &&
        signedIn == true) {
      Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
    } else {
      if (GlobalManager().shouldNavigateToRequest) {
        GlobalManager().navigateToRequest(false);
        Navigator.pushReplacementNamed(context, RequestsScreen.routeName);
        return;
      }

      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
  }
}
