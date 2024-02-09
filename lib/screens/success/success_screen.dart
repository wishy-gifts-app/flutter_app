import 'package:flutter/material.dart';

import 'components/body.dart';

class SuccessScreen extends StatelessWidget {
  static String routeName = "/success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: Body(),
    );
  }
}
