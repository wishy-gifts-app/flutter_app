import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalManager {
  static final GlobalManager _singleton = GlobalManager._internal();

  String? token;
  int? userId;
  String? username;
  bool? signedIn;
  bool shouldNavigateToRequest = false;
  bool? isDeliveryAvailable;
  bool showAnimation = false;

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
  }

  Future<void> setParams({
    String? newToken,
    String? newUsername,
    int? newUserId,
    bool? newSignedIn,
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
      await storage.write(
          key: 'profile_completed', value: newSignedIn.toString());
    }
  }

  void navigateToRequest(bool value) {
    shouldNavigateToRequest = value;
  }

  void setShowAnimation(bool value) {
    showAnimation = value;
  }

  void setDeliveryAvailability(bool value) {
    isDeliveryAvailable = value;
  }
}
