import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";
  final String phoneNumber;

  OtpScreen({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: Body(phoneNumber: phoneNumber),
    );
  }
}
