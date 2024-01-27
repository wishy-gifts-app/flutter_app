import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';

class DeliveryAvailabilityIcon extends StatelessWidget {
  final double size;
  final bool withBackground;

  const DeliveryAvailabilityIcon(
      {Key? key, this.size = 25, this.withBackground = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAvailable = GlobalManager().isDeliveryAvailable ?? true;

    if (!isAvailable) {
      return Container(
          // padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          decoration: BoxDecoration(
            color: withBackground ? Colors.white.withOpacity(0.8) : null,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(Icons.local_shipping, size: size * 0.8),
              Icon(Icons.block, color: Colors.red, size: size * 1.4),
            ],
          ));
    }

    return Container();
  }
}
