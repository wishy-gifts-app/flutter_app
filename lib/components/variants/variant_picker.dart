import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';

class VariantPicker extends StatefulWidget {
  final String type;
  final List<dynamic> values;
  final String? chosenVariant;
  final Function(String, String) onVariantChange;

  const VariantPicker({
    Key? key,
    required this.type,
    required this.values,
    required this.onVariantChange,
    this.chosenVariant,
  }) : super(key: key);

  @override
  _VariantPickerState createState() => _VariantPickerState();
}

class _VariantPickerState extends State<VariantPicker> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.chosenVariant != null)
      selectedIndex =
          widget.values.indexWhere((item) => item == widget.chosenVariant);

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.type}:"),
          SizedBox(height: getProportionateScreenWidth(10)),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              widget.values.length,
              (index) => GestureDetector(
                onTap: widget.chosenVariant == null
                    ? () {
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.onVariantChange(
                            widget.type, widget.values[index]);
                      }
                    : null,
                child: VariantDot(
                  value: widget.values[index],
                  isSelected: index == selectedIndex,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VariantDot extends StatelessWidget {
  final dynamic value;
  final bool isSelected;

  const VariantDot({
    Key? key,
    required this.value,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isSelected ? kPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Text(
        value.toString(),
        style: TextStyle(
          color: isSelected ? Colors.white : kTextColor,
        ),
      ),
    );
  }
}
