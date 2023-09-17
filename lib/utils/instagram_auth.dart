// import 'dart:async';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'dart:io';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shop_app/models/SignInResponse.dart';
// import 'package:shop_app/services/instagram_auth_service.dart';

// Future<SignInResponse> getInstagramToken() async {
//   print(1111);
//   Stream<String> onCode = await _server();
//   final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   flutterWebviewPlugin.launch(dotenv.get("INSTAGRAM_AUTH_URL"));
//   final String code = await onCode.first;
//   final response = await InstagramAuthService().verifyCode(code);
//   flutterWebviewPlugin.close();

//   return response;
// }

// Future<Stream<String>> _server() async {
//   final StreamController<String> onCode = new StreamController();
//   HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8585);
//   server.listen((HttpRequest request) async {
//     final String code = request.uri.queryParameters["code"]!;
//     request.response
//       ..statusCode = 200
//       ..headers.set("Content-Type", ContentType.html.mimeType)
//       ..write("<html><h1>You can now close this window</h1></html>");
//     await request.response.close();
//     await server.close(force: true);
//     onCode.add(code);
//     await onCode.close();
//   });
//   return onCode.stream;
// }
