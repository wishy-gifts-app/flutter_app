import 'package:flutter/material.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/size_config.dart';

class RootScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    await GlobalManager().initialize();
    String? token = GlobalManager().token;
    bool? profileCompleted = GlobalManager().profileCompleted;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    } else if (profileCompleted == null || !profileCompleted) {
      Navigator.pushReplacementNamed(
          context,
          CompleteProfileScreen
              .routeName); // Assuming '/home' is your home page route
    } else {
      Navigator.pushReplacementNamed(context,
          HomeScreen.routeName); // Assuming '/home' is your home page route
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
