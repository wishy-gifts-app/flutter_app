import 'package:flutter/material.dart';
import 'package:shop_app/components/location_dialog_form.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Address.dart';
import 'package:shop_app/screens/checkout/components/payment_button.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/services/graphql_service.dart';

class BuyForYourself extends StatefulWidget {
  final int variantId;

  BuyForYourself({
    required this.variantId,
  });

  @override
  _BuyForYourselfState createState() => _BuyForYourselfState();
}

class _BuyForYourselfState extends State<BuyForYourself> {
  Map<String, dynamic>? _paginationServices;
  List<Address>? _addresses;
  int _selectedAddressIndex = 0;

  Future<void> onSubmit() async {
    try {
      final result = await GraphQLService().queryHandler("checkoutHandler", {
        "variant_id": widget.variantId,
        "address_id": _addresses![_selectedAddressIndex].id,
        "quantity": 1,
      });
      print(result);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Unable to upload payment method. Please check your information and try again.'),
      ));
    }
  }

  Future<void> _initializeData() async {
    final result = await GraphQLService()
        .queryHandler("getUserAddresses", {"limit": 20}, withPagination: true);

    if (mounted) {
      setState(() {
        _paginationServices = result;
      });
    }

    final data = await fetchData();
    if (mounted) {
      setState(() {
        _addresses = data;
      });
    }
  }

  void initState() {
    _initializeData();
    super.initState();
  }

  Future<List<Address>?> fetchData() async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => Address.fromJson(item))
        .toList();

    final nextPageData = await _paginationServices!["nextPage"]();
    return nextPageData != null ? formatResponse(nextPageData) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        if (_addresses != null && _addresses!.length > 0)
          Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: _addresses!.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Address address = entry.value;
                  return ListTile(
                    title: Text(address.country +
                        " " +
                        address.city +
                        " " +
                        address.streetAddress +
                        " " +
                        address.streetNumber),
                    trailing: idx == _selectedAddressIndex
                        ? Icon(Icons.check_circle, color: kPrimaryColor)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedAddressIndex = idx;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        if (_addresses == null || _addresses!.isEmpty)
          Text(
            "You haven't added an address yet.",
            textAlign: TextAlign.center,
          ),
        IconButton(
          icon: Icon(
            Icons.add_location,
            size: 50,
          ),
          tooltip: "Add address",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  Dialog.fullscreen(child: LocationDialogForm()),
            ).then((_) {
              setState(() {
                _selectedAddressIndex = 0;
              });
              _initializeData();
            });
            ;
          },
        ),
        SizedBox(height: getProportionateScreenHeight(100)),
        PaymentButton(
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}
