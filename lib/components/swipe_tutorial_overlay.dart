import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class SwipeTutorialOverlay extends StatefulWidget {
  final VoidCallback onFinished;

  const SwipeTutorialOverlay({Key? key, required this.onFinished})
      : super(key: key);

  @override
  _SwipeTutorialOverlayState createState() => _SwipeTutorialOverlayState();
}

class _SwipeTutorialOverlayState extends State<SwipeTutorialOverlay> {
  int _currentStep = 0;
  static const _animations = [
    'assets/animations/swipe_right.json',
    'assets/animations/swipe_left.json',
    'assets/animations/swipe_up.json',
  ];

  static const _messages = [
    'Like it? Swipe right!',
    'Not your style? Swipe left.',
    'Want this? Swipe up to request!',
  ];

  void _nextStep() {
    if (_currentStep < _animations.length - 1) {
      setState(() {
        this._currentStep++;
      });
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black45,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: Column(
              key: ValueKey<int>(_currentStep),
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedTextKit(
                  key: ValueKey(_currentStep),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      _messages[_currentStep],
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                  totalRepeatCount: 1,
                  onFinished: _nextStep,
                ),
                SizedBox(height: 20),
                Lottie.asset(
                  _animations[_currentStep],
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  repeat: true,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
