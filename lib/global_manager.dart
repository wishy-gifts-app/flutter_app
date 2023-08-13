import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GlobalManager {
  static final GlobalManager _singleton = GlobalManager._internal();

  // Define your global variables
  String? token;
  bool? completedProfile;

  factory GlobalManager() {
    return _singleton;
  }

  GlobalManager._internal();

  // Initialize global variables by fetching from storage
  Future<void> initialize() async {
    final storage = FlutterSecureStorage();
    token = await storage.read(key: 'token');
    String? completedProfileStr = await storage.read(key: 'profile_completed');
    completedProfile = completedProfileStr == 'true';
  }
}
