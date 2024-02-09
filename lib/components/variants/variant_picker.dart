import 'package:Wishy/models/Product.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../size_config.dart';

class VariantPicker extends StatefulWidget {
  final String type;
  final List<Attribute> availableValues;
  final List<Attribute> attributes;
  final String? chosenVariant;
  final Function(Attribute) onVariantChange;

  const VariantPicker({
    Key? key,
    required this.type,
    required this.availableValues,
    required this.attributes,
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
      selectedIndex = widget.attributes
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
                widget.type,
              )),
          SizedBox(height: getProportionateScreenWidth(10)),
          Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(
                  widget.attributes.length,
                  (index) => VariantElement(
                    onSelect: widget.chosenVariant == null
                        ? () {
                            setState(() {
                              selectedIndex = index;
                            });
                            widget.onVariantChange(widget.attributes[index]);
                          }
                        : null,
                    enable: widget.attributes[index]
                        .isExistIn(widget.availableValues),
                    value: widget.attributes[index].value,
                    isSelected: index == selectedIndex,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class VariantElement extends StatelessWidget {
  final dynamic value;
  final bool isSelected;
  final bool enable;
  final void Function()? onSelect;

  const VariantElement({
    Key? key,
    required this.value,
    required this.enable,
    required this.onSelect,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSelected
        ? enable
            ? kPrimaryColor
            : kPrimaryColor.withOpacity(0.4)
        : enable
            ? Colors.transparent
            : kSecondaryColor.withOpacity(0.5);

    Color borderColor = enable ? kPrimaryColor : Colors.transparent;

    Color textColor = isSelected
        ? Colors.white
        : enable
            ? kTextColor
            : Colors.grey;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Opacity(
          opacity: enable ? 1.0 : 0.5,
          child: Text(
            value.toString(),
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
