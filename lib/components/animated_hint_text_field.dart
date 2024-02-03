import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedHintTextField extends StatefulWidget {
  final List<String> hintOptions;
  final TextField textField;
  final double widthPadding;

  AnimatedHintTextField({
    Key? key,
    required this.hintOptions,
    required this.textField,
    this.widthPadding = 18,
  }) : super(key: key);

  @override
  _AnimatedHintTextFieldState createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _showHint = widget.textField.controller?.text == "";
    widget.textField.controller?.addListener(() {
      setState(() {
        _showHint = widget.textField.controller?.text == "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.centerLeft,
        children: [
          widget.textField,
          if (this._showHint)
            Positioned(
                left: widget.widthPadding,
                top: 12,
                child: Container(
                    width: constraints.maxWidth - (widget.widthPadding * 2),
                    child: IgnorePointer(
                        child: Container(
                      width: constraints.maxWidth - (widget.widthPadding * 2),
                      child: AnimatedTextKit(
                        totalRepeatCount: 100,
                        isRepeatingAnimation: true,
                        animatedTexts: widget.hintOptions.map((option) {
                          return TypewriterAnimatedText(
                            option,
                            textStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                            speed: Duration(milliseconds: 50),
                          );
                        }).toList(),
                        pause: Duration(milliseconds: 400),
                        displayFullTextOnTap: true,
                      ),
                    )))),
        ],
      );
    });
  }
}
