import 'package:flutter/material.dart';

import '../size_config.dart';

class TopRoundedContainer extends StatelessWidget {
  const TopRoundedContainer({
    Key? key,
    required this.color,
    required this.child,
    this.margin = 20,
    this.padding = 20,
  }) : super(key: key);

  final Color color;
  final Widget child;
  final double margin;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getProportionateScreenWidth(margin)),
      padding: EdgeInsets.only(top: getProportionateScreenWidth(padding)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }
}
