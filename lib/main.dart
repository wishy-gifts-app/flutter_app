import 'package:Wishy/services/opt_services.dart';
import 'package:Wishy/utils/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Wishy/routes.dart';
import 'package:Wishy/screens/root_screen.dart';
import 'package:Wishy/theme.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await dotenv.load(fileName: "lib/.env");
  await GlobalManager().initialize();
  final uuid = Uuid();
  GlobalManager().setSession(uuid.v1());
  final authServices = AuthServices();

  await AnalyticsService.init({"User Id": GlobalManager().userId});
  updateNotificationPermission();

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
