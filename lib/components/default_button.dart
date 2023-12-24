import 'package:flutter/material.dart';
import 'package:Wishy/utils/analytics.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatefulWidget {
  const DefaultButton({
    Key? key,
    this.eventName,
    this.eventData,
    this.text,
    this.press,
    this.enable = true,
    this.pressBackgroundColor = kPrimaryLightColor,
    this.backgroundColor = kPrimaryColor,
  }) : super(key: key);
  final String? eventName;
  final Map<String, dynamic>? eventData;
  final String? text;
  final Function? press;
  final bool enable;
  final Color backgroundColor, pressBackgroundColor;

  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _isPressed = false;

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
        .map((controller) => Tween(begin: 6.0, end: 9.0).animate(controller))
        .toList();

    _startAnimation();
  }

  void _startAnimation() async {
    while (_isPressed) {
      for (var controller in _controllers) {
        if (!_isPressed) return;
        await controller.forward();
        await Future.delayed(const Duration(milliseconds: 100));
      }
      for (var controller in _controllers.reversed) {
        if (!_isPressed) return;
        controller.reverse();
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _isPressed = false;
    super.dispose();
  }

  void onPress() async {
    if (widget.press != null) {
      setState(() {
        _isPressed = true;
      });
      _startAnimation();

      await widget.press!();

      if (widget.eventName != null) {
        AnalyticsService.trackEvent(widget.eventName!,
            properties: widget.eventData);
      }

      if (mounted)
        setState(() {
          _isPressed = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enable && !_isPressed ? onPress : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: double.infinity,
            height: getProportionateScreenHeight(56),
            decoration: BoxDecoration(
              color: widget.enable
                  ? widget.backgroundColor
                  : widget.pressBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: _isPressed
                  ? Container()
                  : Text(
                      widget.text!,
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          if (_isPressed)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    return Container(
                      height: 8.0,
                      width: _animations[index].value,
                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    );
                  },
                );
              }),
            ),
        ],
      ),
    );
  }
}
