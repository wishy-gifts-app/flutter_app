import 'package:Wishy/screens/requests/components/request_products_list.dart';
import 'requests_header.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  final double headerHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          RequestsHeader(height: headerHeight),
          Expanded(
            child: RequestProductsList(),
          ),
        ],
      ),
    );
  }
}
