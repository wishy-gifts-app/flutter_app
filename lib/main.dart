import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Wishy/routes.dart';
import 'package:Wishy/screens/root_screen.dart';
import 'package:Wishy/theme.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/utils/analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(fileName: "lib/.env");
  await GlobalManager().initialize();

  if (GlobalManager().token != null) {
    try {
      final userLocation = await graphQLQueryHandler("isProductAvailable", {});
      GlobalManager().setUserCountry(userLocation["user_country"]);

      if (userLocation["is_product_available"]) {
        GlobalManager().setDeliveryAvailability(true);
      }
    } catch (error) {
      print(error);
      GlobalManager().setDeliveryAvailability(true);
    }
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
