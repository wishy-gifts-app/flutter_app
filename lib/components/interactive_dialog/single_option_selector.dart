import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';

class SingleOptionSelector extends StatefulWidget {
  final List<String> options;
  final Function(String) onSelect;

  SingleOptionSelector({
    Key? key,
    required this.options,
    required this.onSelect,
  }) : super(key: key);

  @override
  _SingleOptionSelectorState createState() => _SingleOptionSelectorState();
}

class _SingleOptionSelectorState extends State<SingleOptionSelector> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedOption == option ? kPrimaryColor : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedOption = option;
            });
            widget.onSelect(option);
          },
          child: Container(
              constraints: BoxConstraints(
                minHeight: 42,
                minWidth: 180,
                maxHeight:
                    MediaQuery.of(context).size.height / widget.options.length,
                maxWidth: 200,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    option,
                    style: TextStyle(
                      color: selectedOption == option
                          ? Colors.white
                          : kPrimaryColor,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color:
                        selectedOption == option ? Colors.white : kPrimaryColor,
                  ),
                ],
              )),
        );
      }).toList(),
    );
  }
}
