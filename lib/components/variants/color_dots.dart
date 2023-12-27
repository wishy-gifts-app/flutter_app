import 'package:flutter/material.dart';
import 'package:string_to_color/string_to_color.dart';

import '../../constants.dart';
import '../../size_config.dart';

Color getColorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class ColorDots extends StatefulWidget {
  const ColorDots({
    Key? key,
    required this.values,
    required this.onVariantChange,
    this.chosenVariant,
  }) : super(key: key);

  final List<Map<String, dynamic>> values;
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

    widget.onVariantChange("color", widget.values[index]["color"]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chosenVariant != null)
      selectedColor =
          widget.values.indexWhere((item) => item == widget.chosenVariant);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Colors:",
              )),
          SizedBox(height: getProportionateScreenWidth(10)),
          Align(
              alignment: Alignment.center,
              child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(widget.values.length, (index) {
                    print(widget.values[index]);
                    return Tooltip(
                      message: widget.values[index]["color_name"] ?? "",
                      onTriggered: widget.chosenVariant == null
                          ? () => handleChange(index)
                          : null,
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 1),
                      child: ColorDot(
                        color: getColorFromHex(widget.values[index]["color"]),
                        isSelected: index == selectedColor,
                      ),
                    );
                  }))),
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
