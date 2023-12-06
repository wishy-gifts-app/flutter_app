import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:uni_links/uni_links.dart';

class RootScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    try {
      Uri? initialUri = await getInitialUri();

      if (initialUri != null && initialUri.path == '/requests') {
        Navigator.pushReplacementNamed(context, RequestsScreen.routeName);
      } else {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } on Exception {
      // Handle exception (if any)
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
