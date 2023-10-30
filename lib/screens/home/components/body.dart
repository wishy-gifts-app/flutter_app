import 'package:Wishy/models/Tag.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'home_header.dart';
import 'main_products.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final double headerHeight = 60.0;
  Tag? _selectedTag;

  void _onTagSelected(Tag? selectedTag) {
    setState(() {
      _selectedTag = selectedTag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(10)),
          HomeHeader(
            height: headerHeight,
            onTagSelected: _onTagSelected,
          ),
          Expanded(
            child: MainProducts(
              key: ValueKey<int?>(_selectedTag?.id),
              selectedTag: _selectedTag,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
        ],
      ),
    );
  }
}
