import 'package:Wishy/components/support.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/screens/likes/likes_screen.dart';
import 'package:Wishy/screens/matches/matches_screen.dart';
import 'package:Wishy/screens/profile/profile_screen.dart';
import 'dart:async';
import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatefulWidget {
  final MenuState selectedMenu;

  CustomBottomNavBar({Key? key, required this.selectedMenu}) : super(key: key);

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final Color inActiveIconColor = Color(0xFFB6B6B6);
  bool showNewMatchesPoint = false;

  IconButton generateIconButton(String iconPath, MenuState menuState,
      String routPath, BuildContext context,
      {double? height}) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);

    return IconButton(
        icon: SvgPicture.asset(
          iconPath,
          height: height,
          color: menuState == widget.selectedMenu
              ? kPrimaryColor
              : inActiveIconColor,
        ),
        onPressed: () {
          AnalyticsService.trackEvent(
            analyticEvents["PAGE_OPENED"]!,
          );

          if (widget.selectedMenu == MenuState.matches)
            setState(() {
              showNewMatchesPoint = false;
            });
          Navigator.pushNamed(context, routPath);
        });
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
              generateIconButton(
                "assets/icons/matches.svg",
                MenuState.matches,
                MatchesScreen.routeName,
                context,
              ),
              generateIconButton("assets/icons/Chat bubble Icon.svg",
                  MenuState.message, RequestsScreen.routeName, context),
              generateIconButton(
                "assets/icons/User Icon.svg",
                MenuState.profile,
                ProfileScreen.routeName,
                context,
              )
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     generateIconButton("assets/icons/User Icon.svg",
              //         MenuState.profile, ProfileScreen.routeName, context,
              //         height: 22),
              //     if (showNewMatchesPoint)
              //       Positioned(
              //         top: 0,
              //         right: 0,
              //         child: Container(
              //           width: 10,
              //           height: 10,
              //           decoration: BoxDecoration(
              //             color: Colors.red,
              //             shape: BoxShape.circle,
              //           ),
              //         ),
              //       ),
              //   ],
              // ),
            ],
          )),
    );
  }
}
