import 'package:Wishy/global_manager.dart';
import 'package:Wishy/services/opt_services.dart';
import 'package:Wishy/utils/notification.dart';
import 'package:Wishy/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
// import 'package:uni_links/uni_links.dart';

Future<void> initUniLinks() async {
  FlutterBranchSdk.listSession().listen((data) {
    handleBranchDeepLink(data);
  }, onError: (error) {
    print('Branch SDK Error: $error');
  });
}

void handleBranchDeepLink(Map<dynamic, dynamic> data) {
  print(data);
  if (data.containsKey('+clicked_branch_link') &&
      data['+clicked_branch_link']) {
    String? navigationToken;

    if (data.containsKey('custom_target') &&
        data['custom_target'] == 'requests') {
      GlobalManager().setNavigateToRequest(true);
      navigationToken = data['custom_token'];
    } else if (data.containsKey('custom_target') &&
        data['custom_target'] == 'invites') {
      navigationToken = data['custom_token'];
    } else {
      print("Feature deep link not handled: ${data['~feature']}");
    }

    GlobalManager().setNotificationToken(navigationToken);
  }
  GlobalManager().setShowAnimation(GlobalManager().token == null);
  RouterUtils.routeToHomePage();
}

class RootScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final authServices = AuthServices();

  void _handleUserLocation() async {
    try {
      final userLocation = await authServices.userLocationData();
      GlobalManager().setUserLocation(userLocation);

      if (userLocation.isProductsAvailable) {
        GlobalManager().setDeliveryAvailability(true);
      }
    } catch (error) {
      print(error);
      GlobalManager().setDeliveryAvailability(true);
    }
  }

  @override
  void initState() {
    initUniLinks();
    _handleUserLocation();
    updateNotificationPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
