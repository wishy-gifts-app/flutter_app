import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Address.dart';
import 'package:flutter/material.dart';

class AddressesWidget extends StatelessWidget {
  final List<Address> addresses;
  final int? selectedIndex;
  final double? height;
  final Function(int)? onTap;
  final String emptyMessage;
  final bool isGift;

  AddressesWidget({
    this.addresses = const [],
    this.selectedIndex,
    this.onTap,
    this.height = 160,
    this.isGift = false,
    this.emptyMessage = "You haven't added an address yet.",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(15)),
      height: height,
      child: addresses.length > 0
          ? SingleChildScrollView(
              child: Column(
                children: addresses.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Address address = entry.value;
                  return ListTile(
                      title: Text(
                        address.streetAddress + " " + address.streetNumber,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        (address.apartment != "" && address.apartment != null
                                ? address.apartment! + ", "
                                : "") +
                            address.city +
                            ", " +
                            address.state +
                            ", " +
                            address.country,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: selectedIndex != null && idx == selectedIndex
                          ? Icon(Icons.check_circle, color: kPrimaryColor)
                          : null,
                      onTap: onTap != null ? () => onTap!(idx) : null);
                }).toList(),
              ),
            )
          : Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    emptyMessage,
                    textAlign: TextAlign.center,
                  ))),
    );
  }
}
