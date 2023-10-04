import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Wishy/models/SignInResponse.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

Future<SignInResponse> getInstagramToken(BuildContext context) async {
  final String url = dotenv.get("INSTAGRAM_AUTH_URL");
  final String callbackUrlScheme = "wishy";

  final result = await FlutterWebAuth.authenticate(
      url: url, callbackUrlScheme: callbackUrlScheme);

  final data = Uri.parse(result);

  return SignInResponse.fromJson(data.queryParameters);
}
