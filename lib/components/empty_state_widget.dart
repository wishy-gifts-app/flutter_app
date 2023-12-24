import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String body;
  final String CTA;
  final String routeName;

  EmptyStateWidget(
      {this.title = null,
      required this.body,
      required this.CTA,
      required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Center(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                  ],
                  Text(
                    body,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  DefaultButton(
                    text: CTA,
                    press: () => Navigator.pushNamed(
                      context,
                      routeName,
                    ),
                  )
                ]))));
  }
}
