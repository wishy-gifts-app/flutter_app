import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/search_user.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RequestData {
  int? userId;
  String? name;
  String? phone;
  String? reason;
  Variant? selectedVariant;
}

class VariantsAndRequestModal extends StatefulWidget {
  final int productId;
  final String productTitle;
  final List<Variant> variants;

  VariantsAndRequestModal({
    required this.productId,
    required this.productTitle,
    required this.variants,
  });

  @override
  _VariantsAndRequestModalState createState() =>
      _VariantsAndRequestModalState();
}

class _VariantsAndRequestModalState extends State<VariantsAndRequestModal> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  Map<String, dynamic> variants = {};
  RequestData requestData = RequestData();
  Completer<bool>? _phoneValidationCompleter;

  void _onUserSelected(int? userId) {
    requestData.userId = userId;
  }

  void _onNameChanged(String? name) {
    requestData.name = name;
  }

  void _onPhoneChanged(String? phone) {
    requestData.phone = phone;
    _phoneValidationCompleter!.complete(true);
  }

  void _onReasonChanged(String? reason) {
    requestData.reason = reason;
  }

  void _onVariantChosen() {
    requestData.selectedVariant = getSelectedVariant(widget.variants, variants);
  }

  void _onVariantChange(String type, String value) {
    setState(() {
      variants[type] = value;
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _phoneValidationCompleter = Completer<bool>();
      _formKey.currentState!.save();
      await _phoneValidationCompleter!.future;
      _onVariantChosen();

      if (requestData.reason != null &&
              requestData.selectedVariant != null &&
              requestData.userId != null ||
          (requestData.name != null && requestData.phone != null)) {
        try {
          await graphQLQueryHandler("requestProduct", {
            "product_id": widget.productId,
            "variant_id": requestData.selectedVariant!.id,
            "phone_number": requestData.phone,
            "reason": requestData.reason,
            "name": requestData.name,
            "recipient_id": requestData.userId
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Request sent successfully"),
          ));
        } catch (error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error sending request. Please try again."),
          ));
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variants.length > 1) {
      return Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 1) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            _onSubmit();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: Text('Select Your Preferred Variant'),
            content: Column(
              children: [
                VariantsWidget(
                    productVariants: widget.variants,
                    withBuyButton: false,
                    onVariantChange: _onVariantChange),
              ],
            ),
          ),
          Step(
            title: Text('Select Whom You\'d Like to Request From'),
            content: Form(
                key: _formKey,
                child: Column(children: [
                  SearchUserWidget(
                    onUserSelected: _onUserSelected,
                    onNameChanged: _onNameChanged,
                    onPhoneChanged: _onPhoneChanged,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: _onReasonChanged,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return kReasonNullError;
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Request Reason'),
                    maxLines: 3,
                  ),
                ])),
          ),
        ],
      );
    } else {
      return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Text('Select Whom You\'d Like to Request From'),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    SearchUserWidget(
                      onUserSelected: _onUserSelected,
                      onNameChanged: _onNameChanged,
                      onPhoneChanged: _onPhoneChanged,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: _onReasonChanged,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return kReasonNullError;
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Request Reason'),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    DefaultButton(
                      text: "Submit",
                      // eventName: analyticEvents["REQUEST_SUBMITTED"]!,
                      // eventData: {
                      //   "Product Id": widget.productId,
                      //   "Product Title": widget.productTitle,
                      //   "Situation": "Request",
                      //   "Variants Exist": false
                      // },
                      press: _onSubmit,
                    )
                  ]))));
    }
  }
}

void showRequestModal(BuildContext context, int productId, String productTitle,
    List<Variant> variants) async {
  if (!GlobalManager().isDeliveryAvailable!) {
    await DeliveryAvailabilityDialog.show(context);

    if (!GlobalManager().isDeliveryAvailable!) return;
  }

  showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: VariantsAndRequestModal(
              productId: productId,
              productTitle: productTitle,
              variants: variants,
            ));
      });
}