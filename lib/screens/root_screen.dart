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
  bool _navigateToRequest = false;
  @override
  void initState() {
    super.initState();

    _navigateBasedOnToken();
    GlobalManager().setShowAnimation(GlobalManager().token == null);
    GlobalManager().setParams(newToken: null);
  }

  Future<void> _navigateBasedOnToken() async {
    try {
      Uri? initialUri = await getInitialUri();

      if (initialUri != null && initialUri.path == '/requests') {
        _navigateToRequest = true;
        GlobalManager().setNotificationToken(
          initialUri.queryParameters["token"],
        );
      } else if (initialUri != null && initialUri.path == '/invites') {
        GlobalManager().setNotificationToken(
          initialUri.queryParameters["token"],
        );
      }
    } on Exception {
      print("Failed to fetch the URI parameters");
    }

    String? token = GlobalManager().token;
    bool? profileCompleted = GlobalManager().profileCompleted;

    RouterUtils.routeToHomePage(
        context, profileCompleted, token, GlobalManager().signedIn,
        navigateToRequest: _navigateToRequest);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
