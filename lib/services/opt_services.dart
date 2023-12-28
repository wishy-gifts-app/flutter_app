import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/SignInResponse.dart';
import 'package:Wishy/models/UserLocationData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthServices {
  Future<UserLocationData> userLocationData() async {
    final response = await http.get(
      Uri.parse(dotenv.get("LOCATION_DATA_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserLocationData.fromJson(data);
    } else {
      print(
          'Failed to fetch user location data, error_message: ${data["message"]}');
      throw Exception('Failed to fetch user location data');
    }
  }

  Future<SignInResponse> guestSignInService() async {
    final response = await http.post(
      Uri.parse(dotenv.get("GUEST_SIGN_IN_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {"fcm_token": await FirebaseMessaging.instance.getToken()}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(data);
    } else {
      print(
          'Failed to handling guest sign in, error_message: ${data["message"]}');
      throw Exception('Failed to handling guest sign in');
    }
  }

  Future<SignInResponse> notificationSignInService() async {
    final response = await http.post(
      Uri.parse(dotenv.get("NOTIFICATION_SIGN_IN_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body:
          jsonEncode({"notification_token": GlobalManager().notificationToken}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(data);
    } else {
      print(
          'Failed to handling notification sign in, error_message: ${data["message"]}');
      throw Exception('Failed to handling notification sign in');
    }
  }

  Future<SignInResponse> verifyOTPService(
      String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(dotenv.get("VERIFY_OPT_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
        'otp_code': otp,
        "fcm_token": await FirebaseMessaging.instance.getToken(),
        "user_id": GlobalManager().userId
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(data);
    } else {
      print('Failed to verify OTP, error_message: ${data["message"]}');
      throw Exception('Failed to verify OTP');
    }
  }

  Future<bool> sendOTPService(String phoneNumber) async {
    final response = await http.post(
      Uri.parse(dotenv.get("SEND_OPT_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'phone_number': phoneNumber}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to send OTP, error_message: ${data["message"]}');
      throw Exception('Failed to send OTP');
    }
  }
}
