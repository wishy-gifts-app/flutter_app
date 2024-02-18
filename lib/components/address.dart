import 'package:Wishy/models/Address.dart';
import 'package:flutter/material.dart';

class AddressTitle extends StatelessWidget {
  final Address address;
  final double fontSize;
  final TextAlign? textAlign;

  AddressTitle({required this.address, this.fontSize = 16, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      address.name,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AddressSubtitle extends StatelessWidget {
  final Address address;
  final double fontSize;
  final TextAlign? textAlign;

  AddressSubtitle({required this.address, this.fontSize = 13, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      (address.apartment != "" && address.apartment != null
              ? address.apartment! + ", "
              : "") +
          address.streetAddress +
          " " +
          address.streetNumber +
          ", " +
          address.city +
          ", " +
          address.state +
          ", " +
          address.country,
      textAlign: textAlign,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
