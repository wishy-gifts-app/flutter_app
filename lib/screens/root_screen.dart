import 'package:Wishy/global_manager.dart';
import 'package:Wishy/services/opt_services.dart';
import 'package:Wishy/utils/notification.dart';
import 'package:Wishy/utils/router_utils.dart';
import 'package:Wishy/utils/user_details.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

Future<void> initUniLinks() async {
  await FlutterBranchSdk.init(
      useTestKey: false, enableLogging: true, disableTracking: false);

  FlutterBranchSdk.listSession().listen((data) {
    handleBranchDeepLink(data);
  }, onError: (error) {
    print('Branch SDK Error: $error');
  }, cancelOnError: true);

  GlobalManager().setShowAnimation(GlobalManager().token == null);
  RouterUtils.routeToHomePage();
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
    GlobalManager().setShowAnimation(GlobalManager().token == null);
    RouterUtils.routeToHomePage();
  }
}

class RootScreen extends StatefulWidget {
  static String routeName = "/";

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final authServices = AuthServices();

  Future<void> _handleUserLocation() async {
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

  void _onStart() async {
    if (GlobalManager().userLocation == null) await _handleUserLocation();

    initUniLinks();
    updateNotificationPermission();
    if (GlobalManager().userId != null) setUserDetails();
  }

  @override
  void initState() {
    _onStart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
