import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';

class DeliveryAvailabilityIcon extends StatelessWidget {
  final double size;

  const DeliveryAvailabilityIcon({Key? key, this.size = 25}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAvailable = GlobalManager().isDeliveryAvailable ?? true;

    return isAvailable
        ? Icon(
            Icons.local_shipping,
            color: Colors.green,
            size: size,
          )
        : Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(Icons.local_shipping, size: size * 0.8),
              Icon(Icons.block, color: Colors.red, size: size * 1.4),
            ],
          );
  }
}
