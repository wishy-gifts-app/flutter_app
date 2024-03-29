import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/screens/rewards/rewards_screen.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/screens/likes/likes_screen.dart';
import 'package:Wishy/screens/profile/profile_screen.dart';
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

    return generateButton(
      SvgPicture.asset(
        iconPath,
        height: height,
        color: menuState == widget.selectedMenu
            ? kPrimaryColor
            : inActiveIconColor,
      ),
      menuState,
      routPath,
      context,
    );
  }

  IconButton generateImageButton(String imagePath, MenuState menuState,
      String routPath, BuildContext context,
      {double? height}) {
    return generateButton(
      Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: kAlertColor.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 10,
                  offset: Offset(1, 1),
                )
              ],
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: menuState == widget.selectedMenu
                    ? kPrimaryColor
                    : Colors.transparent,
              )),
          child: Image.asset(
            imagePath,
            height: height,
          )),
      menuState,
      routPath,
      context,
    );
  }

  IconButton generateButton(
      Widget child, MenuState menuState, String routPath, BuildContext context,
      {double? height}) {
    return IconButton(
        icon: child,
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
              generateImageButton("assets/images/reward.png", MenuState.rewards,
                  RewardsScreen.routeName, context,
                  height: 30),
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
