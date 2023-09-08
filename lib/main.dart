import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/routes.dart';
import 'package:shop_app/screens/root_screen.dart';
import 'package:shop_app/theme.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/utils/analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await GlobalManager().initialize();
  await AnalyticsService.init({"User Id": GlobalManager().userId});

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnalyticsService(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [CustomNavigatorObserver()],
        title: 'Wishy',
        theme: theme(),
        initialRoute: RootScreen.routeName,
        routes: routes,
      ),
    );
  }
}
