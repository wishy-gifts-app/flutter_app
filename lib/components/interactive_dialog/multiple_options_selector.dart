import 'package:flutter/material.dart';

class MultipleOptionsSelector extends StatefulWidget {
  final List<String> options;
  final Function(List<String>) onSelect;

  MultipleOptionsSelector({
    Key? key,
    required this.options,
    required this.onSelect,
  }) : super(key: key);

  @override
  _MultipleOptionsSelectorState createState() =>
      _MultipleOptionsSelectorState();
}

class _MultipleOptionsSelectorState extends State<MultipleOptionsSelector> {
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      children: widget.options.map((option) {
        return FilterChip(
          label: Text(option),
          selected: selectedOptions.contains(option),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                selectedOptions.add(option);
              } else {
                selectedOptions.removeWhere((String name) => name == option);
              }
            });
            widget.onSelect(selectedOptions);
          },
        );
      }).toList(),
    );
  }
}
