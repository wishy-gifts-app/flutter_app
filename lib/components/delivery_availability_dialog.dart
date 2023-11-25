import 'package:Wishy/constants.dart';
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
              'Looks like you\'re outside the ${marketDetails["country"]} where we currently deliver. If you have an ${marketDetails["country"]} delivery address, you can still place an order.'),
          actions: <Widget>[
            TextButton(
              child: Text('Use ${marketDetails["country"]} Address'),
              onPressed: () {
                GlobalManager().setDeliveryAvailability(true);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Browse Anyway'),
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
