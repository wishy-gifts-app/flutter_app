import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/home/home_screen.dart';

class AnalyticsService extends StatefulWidget {
  static late Mixpanel mixpanel;
  final Widget child;

  static Future<void> init(Map<String, dynamic>? superProperties) async {
    mixpanel = await Mixpanel.init(dotenv.get("MIXPANEL_API_KEY"),
        trackAutomaticEvents: true, superProperties: superProperties);
  }

  static void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    print("Track mixpanel event ${eventName}");
    mixpanel.track(eventName, properties: properties);
  }

  static void registerSuperProperties(Map<String, dynamic> properties) {
    print("Register mixpanel super properties ${properties}");
    mixpanel.registerSuperProperties(properties);
  }

  static void setUserProfile(int userId, Map<String, dynamic> properties) {
    print("Set mixpanel user profile ${properties}");
    mixpanel.identify(userId.toString());

    properties.forEach((key, value) {
      mixpanel.getPeople().set(key, value);
    });
  }

  AnalyticsService({required this.child});

  @override
  _AnalyticsServiceState createState() => _AnalyticsServiceState();
}

class _AnalyticsServiceState extends State<AnalyticsService>
    with WidgetsBindingObserver {
  CustomNavigatorObserver? navigatorObserver;

  @override
  void initState() {
    super.initState();
    navigatorObserver = CustomNavigatorObserver();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AnalyticsService.trackEvent(analyticEvents["END_APP_SESSION"]!);
    } else if (state == AppLifecycleState.resumed) {
      AnalyticsService.trackEvent(analyticEvents["START_APP_SESSION"]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CustomNavigatorObserver extends NavigatorObserver {
  String currentRouteName = HomeScreen.routeName;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    if (route.settings.name == "/") return;

    currentRouteName = route.settings.name ?? HomeScreen.routeName;
    AnalyticsService.trackEvent(analyticEvents["APP_PAGE_VIEWED"]!,
        properties: {'route': currentRouteName});
  }
}
