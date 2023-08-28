import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/models/SignInResponse.dart';

class InstagramAuthService {
  Future<SignInResponse> verifyCode(String code) async {
    final response = await http.post(
      Uri.parse(dotenv.get("VERIFY_INSTAGRAM_CODE_API_URL")),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': code,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SignInResponse.fromJson({...response.headers, ...data});
    } else {
      print(
          'Failed to verify Instagram code, error_message: ${data["message"]}');
      throw Exception('Failed to verify Instagram code');
    }
  }
}
