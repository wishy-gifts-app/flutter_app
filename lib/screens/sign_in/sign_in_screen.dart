import 'package:flutter/material.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/size_config.dart';

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

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      setState(() {
        _loading = false; // Set loading to false if token is not found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // If loading is true, show loader, else show actual content
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
