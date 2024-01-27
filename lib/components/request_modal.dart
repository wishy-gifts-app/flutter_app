import 'package:Wishy/components/animated_hint_text_field.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/delivery_availability_dialog.dart';
import 'package:Wishy/components/search_contact.dart';
import 'package:Wishy/components/variants/variants_widget.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:Wishy/utils/is_variants_exists.dart';
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
  final Product product;
  final String situation;
  final String? cursor;

  VariantsAndRequestModal({
    required this.product,
    required this.situation,
    this.cursor,
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
  final TextEditingController _controller = TextEditingController();

  void _onUserSelected(int? userId, bool? isActiveUser) {
    requestData.userId = userId;
  }

  void _onNameChanged(String? name) {
    requestData.name = name;
  }

  void _onPhoneChanged(String? phone) {
    requestData.phone = phone;
    if (_phoneValidationCompleter != null &&
        !_phoneValidationCompleter!.isCompleted)
      _phoneValidationCompleter!.complete(true);
  }

  void _onVariantChosen() {
    requestData.selectedVariant =
        getSelectedVariant(widget.product.variants!, variants);
  }

  void _onVariantChange(String type, String value) {
    setState(() {
      variants[type] = value;
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (requestData.userId == null) {
        _phoneValidationCompleter = Completer<bool>();
        await _phoneValidationCompleter!.future;
      }
      _onVariantChosen();

      if (requestData.selectedVariant != null && requestData.phone != null) {
        requestData.reason = _controller.text;

        try {
          await graphQLQueryHandler("requestProduct", {
            "product_id": widget.product.id,
            "variant_id": requestData.selectedVariant!.id,
            "phone_number": requestData.phone,
            "reason": requestData.reason,
            "name": requestData.name,
            "recipient_id": requestData.userId,
            "cursor": widget.cursor
          });

          if (isVariantsExists(widget.product.variants))
            AnalyticsService.trackEvent(
                analyticEvents["REQUEST_VARIANT_PICKED"]!,
                properties: {
                  "Product Id": widget.product.id,
                  "Variant Id": requestData.selectedVariant!.id,
                  "Reason": requestData.reason,
                  "Name": requestData.name,
                  "Recipient Id": requestData.userId,
                });

          AnalyticsService.trackEvent(analyticEvents["PRODUCT_REQUESTED"]!,
              properties: {
                "Product Id": widget.product.id,
                "Variant Id": requestData.selectedVariant!.id,
                "Reason": requestData.reason,
                "Name": requestData.name,
                "Recipient Id": requestData.userId,
                "Variants Exist": isVariantsExists(widget.product.variants)
              });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Wish whispered successfully! A notification will be sent when it's noticed."),
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
    if (isVariantsExists(widget.product.variants)) {
      return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Text(
          "Make a Wish Known",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Stepper(
          currentStep: _currentStep,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            void Function()? onStepCancel;
            void Function()? onStepContinue;
            String continueMessage = "Continue";

            if (_currentStep == 0) {
              onStepContinue = () => setState(() {
                    _currentStep += 1;
                  });
              onStepCancel = () => Navigator.pop(context);
            } else {
              continueMessage = "Send a Hint";
              onStepContinue = _onSubmit;
              onStepCancel = () => setState(() {
                    _currentStep -= 1;
                  });
            }

            return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        width: 130,
                        height: 43,
                        child: DefaultButton(
                          press: onStepContinue,
                          text: continueMessage,
                        )),
                    TextButton(
                      onPressed: onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ));
          },
          steps: [
            Step(
              title: Text(
                'Select Your Wish: Choose preferences that define your ideal item.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  wordSpacing: 0.7,
                  height: 1.2,
                ),
              ),
              content: VariantsWidget(
                  product: widget.product,
                  withBuyButton: false,
                  situation: widget.situation,
                  onVariantChange: _onVariantChange),
            ),
            Step(
              title: Text(
                "Send a Hint: Subtly suggest your desired item to friends.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  wordSpacing: 0.7,
                  height: 1.2,
                ),
              ),
              content: _buildContactForm(),
            ),
          ],
        )
      ]));
    } else {
      return Container(
          height: MediaQuery.of(context).size.height * 0.69,
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Text(
                  "Make a Wish Known",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
                Text(
                  "Send a Hint: Subtly suggest your desired item to friends.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    wordSpacing: 0.7,
                    height: 1.2,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(15),
                ),
                _buildContactForm(),
                SizedBox(
                  height: getProportionateScreenHeight(5),
                ),
                DefaultButton(
                  text: "Send a Hint",
                  press: _onSubmit,
                )
              ])));
    }
  }

  Form _buildContactForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          SearchContactWidget(
            onUserSelected: _onUserSelected,
            onNameChanged: _onNameChanged,
            onPhoneChanged: _onPhoneChanged,
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          AnimatedHintTextField(
              hintOptions: [
                "Coffee maker's timer feature - perfect for easy mornings!",
                "Telescope for our star-gazing adventures - a skyward journey awaits!",
                "Chose this mystery book, instantly reminded me of you!"
              ],
              widthPadding: 30,
              textField: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Gift Clue Context',
                  labelStyle: TextStyle(color: Colors.black),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 4,
              )),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Text(
            "Tap to SMS a friend, nudging them toward your ideal gift!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
            ),
          ),
        ]));
  }
}

void showRequestModal(BuildContext context, Product product, String situation,
    {String? cursor = null}) async {
  if (GlobalManager().signedIn != true) {
    GlobalManager().setSignInRelatedProductId(product.id);
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    return;
  }

  if (GlobalManager().isDeliveryAvailable != true) {
    await DeliveryAvailabilityDialog.show(context);

    if (GlobalManager().isDeliveryAvailable != true) return;
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
              product: product,
              situation: situation,
              cursor: cursor,
            ));
      });
}
