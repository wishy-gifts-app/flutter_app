import 'package:flutter/material.dart';
import 'package:Wishy/components/location_dialog_form.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/screens/checkout/components/payment_button.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/graphql_service.dart';

class BuyForYourself extends StatefulWidget {
  final int variantId;

  BuyForYourself({
    required this.variantId,
  });

  @override
  _BuyForYourselfState createState() => _BuyForYourselfState();
}

class _BuyForYourselfState extends State<BuyForYourself> {
  GraphQLPaginationService _paginationServices = new GraphQLPaginationService(
    queryName: "getUserAddresses",
    variables: {"limit": 20},
  );
  List<Address>? _addresses;
  int _selectedAddressIndex = 0;

  Future<void> onSubmit() async {
    try {
      final result = await graphQLQueryHandler("checkoutHandler", {
        "variant_id": widget.variantId,
        "quantity": 1,
        "address_id": _addresses![_selectedAddressIndex].id,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Unable to upload payment method. Please check your information and try again.'),
      ));
    }
  }

  Future<void> fetchData() async {
    final result = await _paginationServices.run();

    if (mounted && result["data"] != null) {
      setState(() {
        _addresses = (result["data"] as List<dynamic>)
            .map((item) => Address.fromJson(item))
            .toList();
      });
    }
  }

  void initState() {
    fetchData();
    super.initState();
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
              fetchData();
            });
            ;
          },
        ),
        SizedBox(height: getProportionateScreenHeight(100)),
        PaymentButton(
          onSubmit: onSubmit,
          enable: _addresses != null && _addresses!.length > 0,
        ),
      ],
    );
  }
}
