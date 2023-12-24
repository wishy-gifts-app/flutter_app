import 'package:Wishy/global_manager.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<Map<String, dynamic>> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  final available =
      settings.authorizationStatus == AuthorizationStatus.authorized;
  final fcmToken = await FirebaseMessaging.instance.getToken();
  AnalyticsService.setUserProfile(
      GlobalManager().userId!, {"Notification Available": available});

  return {"available": available, "fcmToken": fcmToken};
}

Future<void> updateNotificationPermission() async {
  if (GlobalManager().userId == null) return;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.getNotificationSettings();
  Map<String, dynamic>? available = null;

  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
      available = {
        "notification_available": true,
        "fcm_token": await FirebaseMessaging.instance.getToken()
      };
      GlobalManager().setParams(newNotificationAvailable: true);
      AnalyticsService.setUserProfile(
          GlobalManager().userId!, {"Notification Available": true});

      break;
    case AuthorizationStatus.denied:
      available = {"notification_available": false};
      GlobalManager().setParams(newNotificationAvailable: false);
      AnalyticsService.setUserProfile(
          GlobalManager().userId!, {"Notification Available": false});

      break;
    case AuthorizationStatus.notDetermined:
      available = {"notification_available": null};
      break;
    default:
      available = {"notification_available": null};
      break;
  }
  try {
    await graphQLQueryHandler(
        "updateUserById", {...available, "id": GlobalManager().userId});
  } catch (error) {
    print(error);
  }
}
