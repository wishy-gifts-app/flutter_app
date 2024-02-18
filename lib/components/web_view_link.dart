import 'package:Wishy/components/web_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WebViewLinkData {
  final String webViewTitle, uri, linkText;
  final String? text;

  WebViewLinkData({
    required this.webViewTitle,
    required this.uri,
    this.text,
    required this.linkText,
  });
}

class WebViewLink extends StatelessWidget {
  final WebViewLinkData data;

  WebViewLink({required this.data});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: <TextSpan>[
          if (data.text != null)
            TextSpan(
              text: data.text,
            ),
          TextSpan(
            text: data.linkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog.fullscreen(
                        child:
                            WebView(title: data.webViewTitle, uri: data.uri));
                  },
                );
              },
            style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue),
          ),
        ],
      ),
    );
  }
}
