import 'package:Wishy/components/support.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class ProfileHeader extends StatelessWidget {
  final double? height;

  const ProfileHeader({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushNamed(
                  context,
                  HomeScreen.routeName,
                ),
              ),
              SupportWidget(),
            ],
          ),
        ));
  }
}
