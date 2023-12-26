import 'package:Wishy/components/addresses_widget.dart';
import 'package:Wishy/components/search_contact.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/shopify_payment_widget.dart';
import 'package:Wishy/components/location_dialog_form.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/screens/checkout/components/payment_button.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'dart:async';
import 'package:Wishy/utils/analytics.dart';

class PurchaseForm extends StatefulWidget {
  final int variantId;
  final int? recipientId;
  final double price;

  PurchaseForm({
    required this.variantId,
    required this.price,
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
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  Completer<bool>? _phoneValidationCompleter;
  Follower? _defaultUser;

  void _onUserSelected(int? userId, bool? isActiveUser) {
    setState(() {
      this.userId = userId;
    });

    setState(() {
      this._recipientId = this.userId;
    });

    if (_recipientId != null)
      fetchData(_recipientId!);
    else
      setState(() {
        _addresses = [];
      });
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

    if (_phoneValidationCompleter != null)
      _phoneValidationCompleter!.complete(true);
  }

  Future<void> onSubmit() async {
    try {
      if (true) {
        AnalyticsService.trackEvent(analyticEvents["NEW_PURCHASE"]!,
            properties: {
              "Variant Id": widget.variantId,
              "Is Gift": _isGift,
              "Recipient Id": _recipientId
            });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Sorry, purchase feature is currently unavailable. We'll notify you when it's ready. Thank you!"),
        ));

        Navigator.pushNamed(
          context,
          HomeScreen.routeName,
        );
        return;
      }
      setState(() {
        _loading = true;
      });
      final result = await graphQLQueryHandler("checkoutHandler", {
        "variant_id": widget.variantId,
        "quantity": 1,
        "address_id": _addresses![_selectedAddressIndex].id,
        "recipient_id": _isGift ? _recipientId : null
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
        ).then((_) {
          AnalyticsService.trackEvent(analyticEvents["NEW_PURCHASE"]!,
              properties: {
                "Variant Id": widget.variantId,
                "Is Gift": _isGift,
                "Recipient Id": _recipientId
              });

          Navigator.pushNamed(
            context,
            HomeScreen.routeName,
          );
        });
        ;
      } else {
        throw Exception('Payment URL not available');
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });

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
    if (_isGift) {
      graphQLQueryHandler("userById", {"id": userId}).then((result) {
        if (mounted)
          setState(() {
            _defaultUser = Follower(
                name: result["name"],
                phoneNumber: result["phone_number"],
                id: result["id"]);
          });
      });
    }
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
    return Center(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                CheckboxListTile(
                  title: Text("Gift Purchase?"),
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
                  height: getProportionateScreenHeight(_isGift ? 8 : 30),
                ),
                if (_isGift) ...[
                  Text(
                    "Please add the recipient's details",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(4),
                  ),
                  SearchContactWidget(
                    onUserSelected: _onUserSelected,
                    onNameChanged: _onNameChanged,
                    onPhoneChanged: _onPhoneChanged,
                    defaultUser: _defaultUser,
                  ),
                ],
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                AddressesWidget(
                    addresses: _addresses ?? [],
                    emptyMessage:
                        "To deliver your order, please tap the plus icon to add a shipping address.",
                    selectedIndex: _selectedAddressIndex,
                    onTap: (idx) {
                      setState(() {
                        _selectedAddressIndex = idx;
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.add_location,
                      size: 50,
                    ),
                    tooltip: "Add address",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_isGift) {
                          _formKey.currentState!.save();

                          if (userId == null) {
                            _phoneValidationCompleter = Completer<bool>();
                            await _phoneValidationCompleter!.future;
                          }
                        }

                        if (_recipientId != null || phoneNumber != null) {
                          AnalyticsService.trackEvent(
                              analyticEvents["ADD_ADDRESS_PRESSED"]!,
                              properties: {
                                "Variant Id": widget.variantId,
                                "Is Gift": _isGift
                              });
                          showDialog<int>(
                            context: context,
                            builder: (context) => Dialog.fullscreen(
                                child: LocationDialogForm(
                              userId: _recipientId,
                              userName: name,
                              userPhoneNumber: phoneNumber,
                            )),
                          ).then((result) {
                            if (result != null) {
                              setState(() {
                                _recipientId = result;
                                _selectedAddressIndex = 0;
                              });

                              fetchData(_recipientId!);
                            }
                          });
                        }
                      }
                    }),
                SizedBox(
                    height: getProportionateScreenHeight(_isGift ? 20 : 60)),
                PaymentButton(
                  loading: _loading,
                  price: widget.price,
                  onSubmit: onSubmit,
                  enable: _addresses != null && _addresses!.length > 0,
                  eventData: {
                    "Is Gift": _isGift,
                    "Recipient Id": _recipientId,
                    "Variant Id": widget.variantId,
                  },
                ),
              ],
            )));
  }
}
