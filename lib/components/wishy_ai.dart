import 'package:flutter/material.dart';

class WishyAIWithBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.black.withOpacity(0.5),
        radius: 30,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/Wishy AI.png',
            )));
  }
}
