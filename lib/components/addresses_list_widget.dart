import 'package:Wishy/components/address.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:flutter/material.dart';

class AddressesListWidget extends StatelessWidget {
  final List<Address> addresses;
  final int? selectedIndex;
  final double? height;
  final Function(int)? onTap;
  final String emptyMessage;
  final bool isGift;

  AddressesListWidget({
    this.addresses = const [],
    this.selectedIndex,
    this.onTap,
    this.height = 160,
    this.isGift = false,
    this.emptyMessage = "You haven't added an address yet.",
  });
  void _onSelect(int index) {
    onTap!(index);
    AnalyticsService.trackEvent(analyticEvents["ADDRESS_SELECTED"]!,
        properties: {"Address Id": GlobalManager().user!.addresses![index].id});
  }

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
                      title: AddressTitle(address: address),
                      subtitle: AddressSubtitle(address: address),
                      trailing: idx == selectedIndex
                          ? Icon(Icons.check_circle, color: kPrimaryColor)
                          : null,
                      onTap: onTap != null ? () => _onSelect(idx) : null);
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
