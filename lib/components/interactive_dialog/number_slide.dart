import 'package:flutter/material.dart';

class NumberSlider extends StatefulWidget {
  final double min;
  final double max;
  final int divisions;
  final Function(double) onSelect;

  NumberSlider({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.divisions = 10,
    required this.onSelect,
  }) : super(key: key);

  @override
  _NumberSliderState createState() => _NumberSliderState();
}

class _NumberSliderState extends State<NumberSlider> {
  double currentValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentValue != 0) Text('${currentValue.round()}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.min.round()}'),
            Slider(
              value: currentValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: currentValue.round().toString(),
              onChangeEnd: (double value) => widget.onSelect(currentValue),
              onChanged: (double value) {
                setState(() {
                  currentValue = value;
                });
              },
            ),
            Text('${widget.max.round()}'),
          ],
        ),
      ],
    );
  }
}
