import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/requests/components/request_products_list.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'requests_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  final double headerHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          RequestsHeader(height: headerHeight),
          if (GlobalManager().signedIn != true)
            Expanded(
              child: EmptyStateWidget(
                CTA: "Sign In",
                title: "Got a wish tucked away?",
                body:
                    "Sign in and share who holds the key to your desires. We'll nudge them with a secret whisper.",
                routeName: SignInScreen.routeName,
              ),
            ),
          if (GlobalManager().signedIn == true)
            Expanded(
              child: RequestProductsList(),
            ),
        ],
      ),
    );
  }
}
