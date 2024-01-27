import 'package:Wishy/models/Address.dart';
import 'package:flutter/material.dart';

class AddressTitle extends StatelessWidget {
  final Address address;
  AddressTitle({required this.address});

  @override
  Widget build(BuildContext context) {
    return Text(
      address.name,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }
}

class AddressSubtitle extends StatelessWidget {
  final Address address;
  AddressSubtitle({required this.address});

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
      style: TextStyle(fontSize: 13),
    );
  }
}
