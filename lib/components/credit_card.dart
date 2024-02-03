import 'package:flutter/material.dart';

enum CreditCardSize { small, medium }

class CreditCardWidget extends StatelessWidget {
  final String digits;
  final CreditCardSize size;
  final bool isBlack;

  CreditCardWidget({
    required this.digits,
    this.size = CreditCardSize.medium,
    this.isBlack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMedium = size == CreditCardSize.medium;
    return Container(
        height: isMedium ? 45 : 36,
        width: isMedium ? 70 : 55,
        decoration: BoxDecoration(
            color: isBlack ? Colors.black : Colors.white,
            // border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(5)),
        child: Stack(children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Container(
                  width: isMedium ? 11 : 9,
                  height: isMedium ? 8 : 7,
                  decoration: BoxDecoration(
                    color: isBlack ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    digits,
                    style: TextStyle(
                        color: isBlack ? Colors.white : Colors.black,
                        fontSize: isMedium ? 14 : 12,
                        fontWeight: FontWeight.bold),
                  )))
        ]));
  }
}
