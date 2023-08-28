import 'package:flutter/material.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/utils/router_utils.dart';

import 'components/body.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _loading = true; // Set this to true initially to show loading

  @override
  void initState() {
    super.initState();
    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    await GlobalManager().initialize(); // Ensure GlobalManager is initialized
    String? token = GlobalManager().token;
    bool? profileCompleted = GlobalManager().profileCompleted;

    if (token != null && token.isNotEmpty) {
      RouterUtils.routeToHomePage(context, profileCompleted);
    } else {
      setState(() {
        _loading = false; // Set loading to false if token is not found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
      ),
      body: Body(),
    );
  }
}
