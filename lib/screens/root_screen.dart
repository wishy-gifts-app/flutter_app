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
    _initUniLinks();
    _navigateBasedOnToken();
  }

  void _initUniLinks() async {
    try {
      Uri? initialUri = await getInitialUri();

      if (initialUri != null && initialUri.path == '/requests') {
        GlobalManager().navigateToRequest(true);
      }
    } on Exception {
      // Handle exception (if any)
    }
  }

  Future<void> _navigateBasedOnToken({bool toRequestsPage = false}) async {
    await GlobalManager().initialize();
    String? token = GlobalManager().token;
    bool? profileCompleted = GlobalManager().profileCompleted;

    RouterUtils.routeToHomePage(context, profileCompleted, token);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
