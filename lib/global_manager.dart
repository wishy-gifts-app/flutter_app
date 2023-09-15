import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalManager {
  static final GlobalManager _singleton = GlobalManager._internal();

  String? token;
  int? userId;
  String? username;
  bool? profileCompleted;

  factory GlobalManager() {
    return _singleton;
  }

  GlobalManager._internal();

  Future<void> initialize() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: 'token');
    userId = int.tryParse(await storage.read(key: 'user_id') ?? "");
    username = await storage.read(key: 'username');
    String? completedProfileStr = await storage.read(key: 'profile_completed');
    profileCompleted = completedProfileStr == 'true';
  }

  Future<void> setParams({
    String? newToken,
    String? newUsername,
    int? newUserId,
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

    if (newProfileCompleted != null) {
      profileCompleted = newProfileCompleted;
      await storage.write(
          key: 'profile_completed', value: newProfileCompleted.toString());
    }
  }
}
