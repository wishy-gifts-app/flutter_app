import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shop_app/services/opt_services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => new _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = new GlobalKey<FormState>();
  final List<String?> errors = [];
  String phoneNumber = "";
  final otpServices = OTPServices();

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<bool> isValidPhoneNumber(String number) async {
    final PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil();
    try {
      return phoneNumberUtil.validate(number);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "continue",
            press: () async {
              FocusScope.of(context).unfocus();

              _formKey.currentState!.save();

              if (phoneNumber.isEmpty) {
                addError(error: kPhoneNumberNullError);
                return;
              } else {
                try {
                  final isValid = await isValidPhoneNumber(phoneNumber);
                  if (!isValid) {
                    addError(error: kInvalidPhoneNumberError);
                    return;
                  }
                } catch (error) {
                  addError(error: kInvalidPhoneNumberError);
                  return;
                }
              }

              try {
                removeError(error: kInvalidPhoneNumberError);
                await otpServices.sendOTPService(phoneNumber);
                Navigator.pushNamed(
                  context,
                  OtpScreen.routeName,
                  arguments: {'phoneNumber': phoneNumber},
                );
              } catch (error) {
                print(error);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Failed to send OTP. Please try again.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue ?? "",
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number including international prefix",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }
}