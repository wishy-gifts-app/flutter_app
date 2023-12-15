import 'package:Wishy/components/custom_surfix_icon.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';

class PhoneNumberField extends StatefulWidget {
  final Function(String?) onSaved;
  final Function(String) onError;
  final bool withIcon;

  PhoneNumberField(
      {required this.onSaved, required this.onError, this.withIcon = true});

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String? errorMessage;
  String phoneNumber = "";

  Future<bool> isValidPhoneNumber(String? number) async {
    bool isValid = false;

    if (number == null || number.isEmpty) {
      setState(() {
        errorMessage = kPhoneNumberNullError;
      });
    } else {
      final PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil();
      try {
        isValid = await phoneNumberUtil.validate(number);
      } catch (e) {
        isValid = false;
      }
      if (!isValid) {
        setState(() {
          errorMessage = kInvalidPhoneNumberError;
        });
      } else {
        isValid = true;
        setState(() {
          errorMessage = null;
        });
      }
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) async {
        if (await isValidPhoneNumber(newValue)) {
          widget.onSaved(newValue);
        } else {
          widget.onError(errorMessage ?? "");
        }
      },
      onChanged: (value) {
        phoneNumber = value;
        if (value.isNotEmpty) {
          setState(() {
            this.errorMessage = null;
          });
        }
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Phone Number",
        labelStyle: TextStyle(backgroundColor: Colors.white),
        hintText: "e.g. +1123456789",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: widget.withIcon
            ? CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg")
            : null,
        errorText: errorMessage,
      ),
    );
  }
}
