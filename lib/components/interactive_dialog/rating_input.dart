import 'package:flutter/material.dart';

class RatingInput extends StatefulWidget {
  final Function(int) onSelect;

  RatingInput({Key? key, required this.onSelect}) : super(key: key);

  @override
  _RatingInputState createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          padding: EdgeInsets.all(5),
          constraints: BoxConstraints(),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              rating = index + 1;
            });
            widget.onSelect(rating);
          },
        );
      }),
    );
  }
}
