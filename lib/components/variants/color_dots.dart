import 'package:flutter/material.dart';
import 'package:string_to_color/string_to_color.dart';

import '../../constants.dart';
import '../../size_config.dart';

class ColorDots extends StatefulWidget {
  const ColorDots({
    Key? key,
    required this.values,
    required this.onVariantChange,
    this.chosenVariant,
  }) : super(key: key);

  final List<String> values;
  final String? chosenVariant;
  final Function(String, String) onVariantChange;

  @override
  _ColorDotsState createState() => _ColorDotsState();
}

class _ColorDotsState extends State<ColorDots> {
  late int selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = 0;
  }

  void handleChange(int index) {
    setState(() {
      selectedColor = index;
    });

    widget.onVariantChange("color", widget.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chosenVariant != null)
      selectedColor =
          widget.values.indexWhere((item) => item == widget.chosenVariant);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          Text("Colors:"),
          Spacer(),
          ...List.generate(
            widget.values.length,
            (index) => GestureDetector(
              onTap: widget.chosenVariant == null
                  ? () => handleChange(index)
                  : null,
              child: ColorDot(
                color: ColorUtils.stringToColor(
                    widget.values[index].toLowerCase()),
                isSelected: index == selectedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key? key,
    required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
