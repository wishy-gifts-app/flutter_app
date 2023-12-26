import 'package:Wishy/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:uni_links/uni_links.dart';

class RootScreen extends StatelessWidget {
  static String routeName = "/";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
