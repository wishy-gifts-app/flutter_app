import 'package:flutter/material.dart';

import '../../../size_config.dart';

class MatchesHeader extends StatelessWidget {
  final double? height;

  const MatchesHeader({
    Key? key,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Text(
          "Secrets Wishy",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
      ),
    );
  }
}
