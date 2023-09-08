import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/likes/likes_screen.dart';
import 'package:shop_app/screens/matches/matches_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final Color inActiveIconColor = Color(0xFFB6B6B6);
  final MenuState selectedMenu;

  IconButton generateIconButton(String iconPath, MenuState menuState,
      String routPath, BuildContext context,
      {double? height}) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);

    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        height: height,
        color: menuState == selectedMenu ? kPrimaryColor : inActiveIconColor,
      ),
      onPressed: () => Navigator.pushNamed(context, routPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              generateIconButton("assets/icons/Shop Icon.svg", MenuState.home,
                  HomeScreen.routeName, context),
              generateIconButton("assets/icons/Heart Icon.svg",
                  MenuState.favorite, LikesScreen.routeName, context),
              generateIconButton("assets/icons/matches.svg", MenuState.matches,
                  MatchesScreen.routeName, context,
                  height: 22),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                onPressed: () {},
              ),
              generateIconButton("assets/icons/User Icon.svg",
                  MenuState.profile, ProfileScreen.routeName, context),
            ],
          )),
    );
  }
}
