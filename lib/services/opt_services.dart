import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OtpVerificationResponse {
  final String token;
  final bool profileCompleted;
  final int userId;

  OtpVerificationResponse(
      {required this.token,
      required this.profileCompleted,
      required this.userId});
}

class OTPServices {
  Future<OtpVerificationResponse> verifyOTPService(
      String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(dotenv.get("VERIFY_OPT_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
        'otp_code': otp,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return OtpVerificationResponse(
        token: response.headers['auth'] ?? "",
        profileCompleted: data['profile_completed'] as bool,
        userId: data['user_id'] as int,
      );
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
      body: jsonEncode({
        'phone_number': phoneNumber,
      }),
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
