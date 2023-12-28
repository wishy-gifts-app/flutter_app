import 'package:Wishy/components/interactive_dialog/chat_message.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final String profilePicture;
  final Color bubbleColor;
  final Color dotColor;

  const TypingIndicator({
    Key? key,
    required this.profilePicture,
    this.bubbleColor = const Color(0xFFE0E0E0),
    this.dotColor = Colors.black,
  }) : super(key: key);

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _animationDisposed = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _animations = _controllers
        .map(
          (controller) => Tween(begin: 4.0, end: 8.0).animate(controller),
        )
        .toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (!this._animationDisposed) {
      for (var controller in _controllers) {
        if (this._animationDisposed) return;
        await Future.delayed(const Duration(milliseconds: 150));
        if (this._animationDisposed) return;
        controller.forward();
      }
      if (this._animationDisposed) return;
      await Future.delayed(const Duration(milliseconds: 150));
      for (var controller in _controllers.reversed) {
        if (this._animationDisposed) return;
        controller.reverse();
      }
      if (this._animationDisposed) return;
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileIcon(),
        SizedBox(width: 8),
        Container(
          height: 42,
          width: 80,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.bubbleColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(3, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Container(
                    height: 8.0,
                    width: _animations[index].value,
                    margin: EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      color: widget.dotColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                },
              );
            }),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }

    _animationDisposed = true;
    super.dispose();
  }
}
