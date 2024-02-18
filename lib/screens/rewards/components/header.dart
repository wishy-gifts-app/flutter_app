import 'package:flutter/material.dart';

import '../../../size_config.dart';

class Header extends StatelessWidget {
  final double? height;

  const Header({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: Text("Wishy Rewards",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: getProportionateScreenWidth(16),
                ))));
  }
}
