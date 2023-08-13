import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // This will close the app when back button is pressed instead of navigating to a previous screen.
        await SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Body(),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        ),
      ),
    );
  }
}
