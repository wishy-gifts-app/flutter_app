import 'package:flutter/material.dart';

class ButtonCards extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;

  const ButtonCards({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(child: child, onTap: onTap);
  }
}
