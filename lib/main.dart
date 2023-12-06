import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Wishy/routes.dart';
import 'package:Wishy/screens/root_screen.dart';
import 'package:Wishy/theme.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/utils/analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await GlobalManager().initialize();
  if (GlobalManager().token == null) {
    //TODO create user or fetch
    final result = {"show_animation": true};
    GlobalManager().setShowAnimation(result["show_animation"]!);
  }

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
