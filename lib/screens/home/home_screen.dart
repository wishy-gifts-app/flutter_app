import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Wishy/components/custom_bottom_nav_bar.dart';
import 'package:Wishy/enums.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) async {
        await SystemNavigator.pop();
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
