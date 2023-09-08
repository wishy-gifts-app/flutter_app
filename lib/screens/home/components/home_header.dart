import 'package:flutter/material.dart';

import '../../../size_config.dart';

class HomeHeader extends StatelessWidget {
  final double? height;

  const HomeHeader({
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wishy",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getProportionateScreenWidth(16),
              ),
            ),
            IconButton(
              icon: Icon(Icons.filter_list), // Filter icon
              onPressed: () {
                // Filter action
              },
            ),
          ],
        ),
      ),
    );
  }
}
