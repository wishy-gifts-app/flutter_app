import 'package:Wishy/global_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

Future<bool> saveFollowers(List<Map<String, String>> followers) async {
  List<List<Map<String, String>>> chunks = [];
  for (var i = 0; i < followers.length; i += 50) {
    chunks.add(followers.sublist(
        i, i + 50 > followers.length ? followers.length : i + 50));
  }

  bool allSuccessful = true;

  for (var chunk in chunks) {
    bool result = await _saveChunk(chunk);
    if (!result) {
      allSuccessful = false;
    }
  }

  return allSuccessful;
}

Future<bool> _saveChunk(List<Map<String, String>> chunk) async {
  try {
    final token = GlobalManager().token;
    final response = await http.post(
      Uri.parse(dotenv.get("FOLLOWERS_API_URL")),
      headers: {"Content-Type": "application/json", "auth": token!},
      body: jsonEncode({
        'followers': chunk,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to save followers chunk');
    }
  } catch (error) {
    print(error);
    return false;
  }
}
