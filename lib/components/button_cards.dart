import 'package:flutter/material.dart';

class ButtonCards extends StatefulWidget {
  final void Function()? onTap;
  final Widget child;

  const ButtonCards({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  _ButtonCardsState createState() => _ButtonCardsState();
}

class _ButtonCardsState extends State<ButtonCards> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: widget.child,
        onHover: (v) {
          setState(() {
            isHover = v;
          });
        },
        onTap: widget.onTap);
  }
}
