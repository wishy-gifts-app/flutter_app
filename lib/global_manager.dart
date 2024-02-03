import 'package:Wishy/models/UserDetails.dart';
import 'package:Wishy/models/UserPaymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Wishy/models/UserLocationData.dart';

class GlobalManager with ChangeNotifier {
  static final GlobalManager _singleton = GlobalManager._internal();

  String? token = null;
  int? userId;
  UserDetails? user;
  bool signedIn = false;
  String? notificationToken = null;
  bool? isDeliveryAvailable;
  UserLocationData? userLocation;
  bool showAnimation = false;
  bool showUpAnimation = false;
  bool? profileCompleted;
  int? signInRelatedProductId = null;
  String? session = null;
  bool recommendationExists = false;
  bool? notificationAvailable = null;
  bool? newConnectAvailable = null;
  String? connectUser = null;
  int? connectUserId = null;
  String? firstFeedCursor = null;
  bool navigateToRequest = false;
  String? paymentSession;
  String? paymentId;

  factory GlobalManager() {
    return _singleton;
  }

  GlobalManager._internal();

  Future<void> initialize() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: 'token');
    userId = int.tryParse(await storage.read(key: 'user_id') ?? "");
    String? signedInStr = await storage.read(key: 'signed_in');
    signedIn = signedInStr == 'true';
    String? completedProfileStr = await storage.read(key: 'profile_completed');
    profileCompleted = completedProfileStr == 'true';
    String? notificationAvailableStr =
        await storage.read(key: 'notification_available');
    notificationAvailable = notificationAvailableStr == null
        ? null
        : notificationAvailableStr == 'true';
  }

  Future<void> setParams({
    String? newToken,
    int? newUserId,
    bool? newSignedIn,
    bool? newProfileCompleted,
    bool? newNotificationAvailable,
  }) async {
    final storage = FlutterSecureStorage();

    if (newToken != null) {
      token = newToken;
      await storage.write(key: 'token', value: newToken);
    }

    if (newUserId != null) {
      userId = newUserId;
      await storage.write(key: 'user_id', value: newUserId.toString());
    }

    if (newSignedIn != null) {
      signedIn = newSignedIn;
      await storage.write(key: 'signed_in', value: newSignedIn.toString());
    }

    if (newProfileCompleted != null) {
      profileCompleted = newProfileCompleted;
      await storage.write(
          key: 'profile_completed', value: newProfileCompleted.toString());
    }

    if (newNotificationAvailable != null) {
      notificationAvailable = newNotificationAvailable;
      await storage.write(
          key: 'notification_available',
          value: newNotificationAvailable.toString());
    }
  }

  void setShowAnimation(bool value) => showAnimation = value;
  void setShowUpAnimation(bool value) => showUpAnimation = value;
  void setSession(String value) => session = value;
  void setDeliveryAvailability(bool value) => isDeliveryAvailable = value;
  void setNewConnectAvailable(bool value) => newConnectAvailable = value;
  void setUserLocation(UserLocationData value) => userLocation = value;
  void setRecommendationExists(bool value) => recommendationExists = value;
  void setSignInRelatedProductId(int? value) => signInRelatedProductId = value;
  void setConnectUser(String? value) => connectUser = value;
  void setConnectUserId(int? value) => connectUserId = value;
  void setFirstFeedCursor(String? value) => firstFeedCursor = value;
  void setNotificationToken(String? value) => notificationToken = value;
  void setNavigateToRequest(bool value) => navigateToRequest = value;
  void setPaymentSession(String? value) => paymentSession = value;
  void setPaymentId(String? value) {
    paymentId = value;
    notifyListeners();
  }

  void setUser(UserDetails? value) {
    user = value;
    notifyListeners();
  }

  void insertPaymentCard(UserPaymentMethod value) {
    if (user == null) throw Exception("User not defined");

    user!.paymentMethods = [value, ...user!.paymentMethods];
    notifyListeners();
  }

  void setPaymentsAfterCheckout(int? index) {
    if (user == null || user!.paymentMethods.length == 0) return;

    if ((index != null && index > 0 && index < user!.paymentMethods.length)) {
      UserPaymentMethod item = user!.paymentMethods.removeAt(index);
      user!.paymentMethods.insert(0, item);
    }

    user!.paymentMethods =
        user!.paymentMethods.where((card) => card.saved).toList();

    notifyListeners();
  }
}
