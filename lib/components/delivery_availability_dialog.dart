import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';

class DeliveryAvailabilityDialog {
  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text('Delivery Availability Notice'),
          content: Text(
              'Looks like you\'re outside the USA where we currently deliver. If you have a US delivery address, you can still place an order.'),
          actions: <Widget>[
            TextButton(
              child: Text('I have a US address'),
              onPressed: () {
                GlobalManager().setDeliveryAvailability(true);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Continue Browsing'),
              onPressed: () {
                GlobalManager().setDeliveryAvailability(false);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
