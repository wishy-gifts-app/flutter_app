import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';

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
    required this.attributes,
    required this.onVariantChange,
    required this.availableValues,
    this.chosenVariant,
  }) : super(key: key);

  final List<Attribute> attributes;
  final String? chosenVariant;
  final List<Attribute> availableValues;
  final Function(Attribute) onVariantChange;

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

    widget.onVariantChange(widget.attributes[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chosenVariant != null)
      selectedColor = widget.attributes
          .indexWhere((item) => item.value == widget.chosenVariant);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Color:",
              )),
          SizedBox(height: getProportionateScreenWidth(10)),
          Align(
              alignment: Alignment.center,
              child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(widget.attributes.length, (index) {
                    return Tooltip(
                      message: widget.attributes[index].value,
                      onTriggered: widget.chosenVariant == null
                          ? () => handleChange(index)
                          : null,
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 1),
                      child: ColorDot(
                        enable: widget.attributes[index]
                            .isExistIn(widget.availableValues),
                        color: getColorFromHex(
                            widget.attributes[index].additionalData!),
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
    required this.enable,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 2),
        child: Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                height: getProportionateScreenWidth(40),
                width: getProportionateScreenWidth(40),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                      width: 2,
                      color: isSelected ? kPrimaryColor : Colors.transparent),
                  shape: BoxShape.circle,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: 3,
                        offset: Offset(0, 0),
                      ),
                    ],
                    color: !enable ? color.withOpacity(0.4) : color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (!enable)
                Icon(
                  Icons.close_rounded,
                  size: 38,
                  color: kSecondaryColor,
                ),
            ]));
  }
}

class SlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final slashPaint = Paint()
      ..color = kSecondaryColor
      ..strokeWidth = 4;

    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    final startPoint = Offset(0, 0);
    final endPoint = Offset(size.width, size.height);

    canvas.drawLine(startPoint, endPoint, borderPaint);
    canvas.drawLine(startPoint, endPoint, slashPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
