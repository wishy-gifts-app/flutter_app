import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  final bool navigateToRequest;

  SignInScreen({this.navigateToRequest = false});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sign In"),
      ),
      body: Body(
        navigateToRequest: navigateToRequest,
      ),
    );
  }
}
