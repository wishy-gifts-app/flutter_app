import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final ImageProvider<Object>? image;
  final double radius;

  CircleImage({required this.image, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: CircleAvatar(
        backgroundImage: image,
        radius: radius,
        backgroundColor: Colors.white,
      ),
    );
  }
}
