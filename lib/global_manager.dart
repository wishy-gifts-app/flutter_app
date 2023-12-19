import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Wishy/models/UserLocationData.dart';

class GlobalManager {
  static final GlobalManager _singleton = GlobalManager._internal();

  String? token = null;
  int? userId;
  String? username;
  bool signedIn = false;
  bool shouldNavigateToRequest = false;
  bool? isDeliveryAvailable;
  UserLocationData? userLocation;
  bool showAnimation = false;
  bool? profileCompleted;
  int? signInRelatedProductId = null;
  String? session = null;
  String? connectUser = null;
  bool recommendationExists = false;

  factory GlobalManager() {
    return _singleton;
  }

  GlobalManager._internal();

  Future<void> initialize() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: 'token');
    userId = int.tryParse(await storage.read(key: 'user_id') ?? "");
    username = await storage.read(key: 'username');
    String? signedInStr = await storage.read(key: 'signed_in');
    signedIn = signedInStr == 'true';
    String? completedProfileStr = await storage.read(key: 'profile_completed');
    profileCompleted = completedProfileStr == 'true';
  }

  Future<void> setParams({
    String? newToken,
    String? newUsername,
    int? newUserId,
    bool? newSignedIn,
    bool? newProfileCompleted,
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

    if (newUsername != null) {
      username = newUsername;
      await storage.write(key: 'username', value: newUsername);
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
  }

  void navigateToRequest(bool value) {
    shouldNavigateToRequest = value;
  }

  void setShowAnimation(bool value) {
    showAnimation = value;
  }

  void setSession(String value) {
    session = value;
  }

  void setDeliveryAvailability(
    bool value,
  ) {
    isDeliveryAvailable = value;
  }

  void setUserLocation(
    UserLocationData value,
  ) {
    userLocation = value;
  }

  void setConnectUser(
    String? value,
  ) {
    connectUser = value;
  }

  void setRecommendationExists(
    bool value,
  ) {
    recommendationExists = value;
  }

  void setSignInRelatedProductId(
    int? value,
  ) {
    signInRelatedProductId = value;
  }
}
