import 'package:flutter/material.dart';
import 'package:Wishy/components/custom_bottom_nav_bar.dart';
import 'package:Wishy/enums.dart';

import 'components/body.dart';

class LikesScreen extends StatelessWidget {
  static String routeName = "/likes";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.favorite),
      ),
    );
  }
}
