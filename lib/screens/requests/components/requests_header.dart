import 'package:flutter/material.dart';

import '../../../size_config.dart';

class RequestsHeader extends StatelessWidget {
  final double? height;

  const RequestsHeader({
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
          "Wishy",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: getProportionateScreenWidth(16),
          ),
        ),
        //  Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // children: [

        // IconButton(
        //   icon: Icon(Icons.filter_list), // Filter icon
        //   onPressed: () {
        //     // Filter action
        //   },
        // ),
        // ],
        // ),
      ),
    );
  }
}
