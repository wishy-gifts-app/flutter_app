import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedHintTextField extends StatefulWidget {
  final List<String> hintOptions;
  final TextField textField;

  AnimatedHintTextField({
    Key? key,
    required this.hintOptions,
    required this.textField,
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
                left: 18,
                top: 12,
                child: Container(
                  width: constraints.maxWidth - 30,
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
                )),
        ],
      );
    });
  }
}
