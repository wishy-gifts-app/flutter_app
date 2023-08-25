import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/profile/components/profile_pic.dart';
import 'personal_info_tab.dart';
import 'orders_tab.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfilePic(),
        SizedBox(height: 10),
        TabBar(
          labelColor: Colors.black,
          indicatorColor: kPrimaryColor,
          controller: _controller,
          tabs: [
            Tab(text: "Personal Info"),
            Tab(text: "Orders"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              PersonalInfoTab(),
              OrdersTab(),
            ],
          ),
        ),
      ],
    );
  }
}
