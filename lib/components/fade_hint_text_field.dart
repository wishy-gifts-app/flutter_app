import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FadeHintTextField extends StatefulWidget {
  final List<String> hintOptions;
  final TextFormField textField;

  FadeHintTextField({
    Key? key,
    required this.hintOptions,
    required this.textField,
  }) : super(key: key);

  @override
  _FadeHintTextFieldState createState() => _FadeHintTextFieldState();
}

class _FadeHintTextFieldState extends State<FadeHintTextField> {
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _showHint = widget.textField.controller?.text.isEmpty ?? true;
    widget.textField.controller?.addListener(_updateHintVisibility);
  }

  @override
  void dispose() {
    widget.textField.controller?.removeListener(_updateHintVisibility);
    super.dispose();
  }

  void _updateHintVisibility() {
    print(widget.textField.controller?.text.isEmpty);

    if (mounted) {
      setState(() {
        _showHint = widget.textField.controller?.text.isEmpty ?? true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        widget.textField,
        if (_showHint)
          Positioned(
            left: 42,
            top: 19,
            child: IgnorePointer(
              child: Container(
                alignment: Alignment.center,
                child: AnimatedTextKit(
                  stopPauseOnTap: true,
                  key: Key('hint'),
                  isRepeatingAnimation: true,
                  totalRepeatCount: 100,
                  animatedTexts: widget.hintOptions.map((option) {
                    return FadeAnimatedText(
                      option,
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                      fadeOutBegin: 0.9,
                      fadeInEnd: 0.1,
                      duration: Duration(milliseconds: 4000),
                    );
                  }).toList(),
                  displayFullTextOnTap: false,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
