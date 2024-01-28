import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';

class StripePoweredWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.verified,
            color: kPrimaryColor,
            size: 18,
          ),
          SizedBox(width: 4),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text: 'Powered and Secured by ',
                  style: TextStyle(color: kSecondaryColor, fontSize: 13),
                ),
                TextSpan(
                  text: 'Stripe',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
