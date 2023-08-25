import 'package:flutter/material.dart';

import '../../../size_config.dart';

class LikesHeader extends StatelessWidget {
  final double? height;

  const LikesHeader({
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
          child: Text("Wishy")),
    );
  }
}
