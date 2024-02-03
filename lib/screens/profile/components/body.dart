import 'package:Wishy/components/empty_state_widget.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/profile/components/profile_header.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/screens/profile/components/profile_pic.dart';
import 'personal_info_tab.dart';
import 'orders_tab.dart';

final tabs = ["Orders", "Personal Info"];

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  TabController? _controller;

  void _handleTabSelection() {
    if (_controller!.indexIsChanging) {
      AnalyticsService.trackEvent(analyticEvents["PROFILE_TAB_PRESSED"]!,
          properties: {
            "Tab": tabs[_controller!.index],
          });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _controller!.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: getProportionateScreenHeight(35)),
      ProfileHeader(height: 50),
      if (GlobalManager().profileCompleted != true)
        Expanded(
            child: EmptyStateWidget(
                title: "Personalize Your Journey",
                body:
                    "Dive into the world of Wishy. Sign in to tailor your profile and discover features crafted just for you.",
                CTA: GlobalManager().signedIn
                    ? "Complete Your Profile"
                    : "Sign In & Explore",
                routeName: GlobalManager().signedIn
                    ? CompleteProfileScreen.routeName
                    : SignInScreen.routeName)),
      if (GlobalManager().profileCompleted == true) ...[
        ProfilePic(),
        SizedBox(height: 10),
        TabBar(
          labelColor: kPrimaryColor,
          indicatorColor: kPrimaryColor,
          controller: _controller,
          tabs: [
            Tab(text: tabs[0]),
            Tab(text: tabs[1]),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              OrdersTab(),
              PersonalInfoTab(),
            ],
          ),
        ),
      ],
    ]);
  }
}
