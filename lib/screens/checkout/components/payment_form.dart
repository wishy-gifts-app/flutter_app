import 'package:flutter/material.dart';

class PaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: 'Recipient Name'),
        ),
        TextField(
          decoration: InputDecoration(hintText: 'Recipient Phone Number'),
        ),
      ],
    );
  }
}
