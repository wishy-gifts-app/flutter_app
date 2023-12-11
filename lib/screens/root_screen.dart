import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/router_utils.dart';
// import 'package:Wishy/utils/router_utils.dart';
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

    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    try {
      Uri? initialUri = await getInitialUri();

      if (initialUri != null && initialUri.path == '/requests') {
        GlobalManager().navigateToRequest(true);
      }
    } on Exception {
      print("Failed to fetch the URI parameters");
    }

    String? token = GlobalManager().token;
    bool? profileCompleted = GlobalManager().profileCompleted;

    RouterUtils.routeToHomePage(
        context, profileCompleted, token, GlobalManager().signedIn);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
