import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';

class DeliveryAvailabilityDialog {
  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen();
      },
    );
  }
}
