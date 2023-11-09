import 'package:Wishy/components/search_user.dart';
import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/shopify_payment_widget.dart';
import 'package:Wishy/components/location_dialog_form.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/screens/checkout/components/payment_button.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'dart:async';

class PurchaseForm extends StatefulWidget {
  final int variantId;
  final int? recipientId;

  PurchaseForm({
    required this.variantId,
    this.recipientId,
  });

  @override
  _PurchaseFormState createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  late GraphQLPaginationService _paginationServices;
  List<Address>? _addresses;
  int _selectedAddressIndex = 0;
  int? userId;
  String? name, phoneNumber;
  late bool _isGift;
  int? _recipientId;
  final _formKey = GlobalKey<FormState>();
  Completer<bool>? _phoneValidationCompleter;

  void _onUserSelected(int? userId) {
    setState(() {
      this.userId = userId;
    });

    if (this.userId != null) {
      setState(() {
        this._recipientId = this.userId!;
      });
    }

    if (_recipientId != null) fetchData(_recipientId!);
  }

  void _onNameChanged(String? name) {
    setState(() {
      this.name = name;
    });
  }

  void _onPhoneChanged(String? phone) {
    setState(() {
      this.phoneNumber = phone;
    });

    _phoneValidationCompleter!.complete(true);
  }

  Future<void> onSubmit() async {
    try {
      final result = await graphQLQueryHandler("checkoutHandler", {
        "variant_id": widget.variantId,
        "quantity": 1,
        "address_id": _addresses![_selectedAddressIndex].id,
      });

      if (result != null && result["payment_url"] != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog.fullscreen(
              child: CheckoutWebView(checkoutUrl: result["payment_url"]),
            );
          },
        );
      } else {
        throw Exception('Payment URL not available');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Unable to upload payment method. Please check your information and try again.'),
      ));
    }
  }

  Future<void> fetchData(int userId) async {
    _paginationServices = new GraphQLPaginationService(
      queryName: "getUserAddresses",
      variables: {"limit": 20, "user_id": userId},
    );
    final result = await _paginationServices.run();

    if (mounted && result["data"] != null && _recipientId != null) {
      setState(() {
        _addresses = (result["data"] as List<dynamic>)
            .map((item) => Address.fromJson(item))
            .toList();
      });
    }
  }

  void initState() {
    _isGift = widget.recipientId != null;
    _recipientId = _isGift && widget.recipientId != null
        ? widget.recipientId!
        : GlobalManager().userId!;
    ;

    fetchData(_recipientId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            CheckboxListTile(
              title: Text("Is this purchase a gift?"),
              value: _isGift,
              onChanged: (bool? newValue) {
                setState(() {
                  _addresses = [];
                  _recipientId =
                      (newValue ?? false) ? null : GlobalManager().userId!;
                  _isGift = newValue ?? false;
                });

                if (!_isGift) {
                  fetchData(GlobalManager().userId!);
                }
              },
              secondary: const Icon(Icons.card_giftcard),
            ),
            SizedBox(
              height: getProportionateScreenHeight(10),
            ),
            if (_isGift) ...[
              SearchUserWidget(
                onUserSelected: _onUserSelected,
                onNameChanged: _onNameChanged,
                onPhoneChanged: _onPhoneChanged,
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
            ],
            if (_addresses != null && _addresses!.length > 0)
              Container(
                height: 180,
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
                _isGift ? "" : "You haven't added an address yet.",
                textAlign: TextAlign.center,
              ),
            IconButton(
                icon: Icon(
                  Icons.add_location,
                  size: 50,
                ),
                tooltip: "Add address",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _phoneValidationCompleter = Completer<bool>();
                    _formKey.currentState!.save();
                    await _phoneValidationCompleter!.future;

                    if (_recipientId != null ||
                        (name != null && phoneNumber != null)) {
                      showDialog<int>(
                        context: context,
                        builder: (context) => Dialog.fullscreen(
                            child: LocationDialogForm(
                          userId: _recipientId,
                          userName: name,
                          userPhoneNumber: phoneNumber,
                        )),
                      ).then((result) {
                        setState(() {
                          _recipientId = result;
                          _selectedAddressIndex = 0;
                        });

                        fetchData(_recipientId!);
                      });
                    }
                  }
                }),
            SizedBox(height: getProportionateScreenHeight(10)),
            PaymentButton(
              onSubmit: onSubmit,
              enable: _addresses != null && _addresses!.length > 0,
            ),
          ],
        ));
  }
}
