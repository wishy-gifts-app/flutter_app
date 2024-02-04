import 'package:flutter/material.dart';
import 'package:Wishy/components/custom_bottom_nav_bar.dart';
import 'package:Wishy/enums.dart';

import 'components/body.dart';

class RewardsScreen extends StatelessWidget {
  static String routeName = "/rewards";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.rewards),
    );
  }
}
