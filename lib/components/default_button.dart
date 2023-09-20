import 'package:flutter/material.dart';
import 'package:Wishy/utils/analytics.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.eventName,
    this.eventData,
    this.text,
    this.press,
  }) : super(key: key);
  final String? eventName;
  final Map<String, dynamic>? eventData;
  final String? text;
  final Function? press;

  void onPress() {
    if (press != null) press!();

    if (eventName != null)
      AnalyticsService.trackEvent(eventName!, properties: eventData);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          foregroundColor: Colors.white,
          backgroundColor: kPrimaryColor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
