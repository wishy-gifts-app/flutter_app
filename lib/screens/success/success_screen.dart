import 'package:flutter/material.dart';

import 'components/body.dart';

class SuccessScreen extends StatelessWidget {
  static String routeName = "/success";
  final SuccessTypes type;

  const SuccessScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: Body(
        type: type,
      ),
    );
  }
}
