import 'package:Wishy/components/custom_surfix_icon.dart';
import 'package:Wishy/components/fade_hint_text_field.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';

class PhoneNumberField extends StatefulWidget {
  final Function(String) onSaved;
  final Function(String) onError;
  final bool withIcon;
  final TextEditingController? controller;
  final List<String> hintOptions;

  PhoneNumberField(
      {required this.onSaved,
      required this.onError,
      this.withIcon = true,
      this.hintOptions = const ["Add manually instead", "E.g. +1123456789"],
      this.controller = null});

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  String? errorMessage;
  String phoneNumber = "";

  Future<String?> isValidPhoneNumber(String? number) async {
    bool isValid = false;

    if (number == null || number.isEmpty) {
      return kPhoneNumberNullError;
    } else {
      final PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil();
      try {
        isValid = await phoneNumberUtil.validate(number);
      } catch (e) {
        isValid = false;
      }
      if (!isValid) {
        return kInvalidPhoneNumberError;
      } else {
        return null;
      }
    }
  }

  void updateIfValid(String? number) async {
    String? result = await isValidPhoneNumber(number);

    if (result == null)
      widget.onSaved(number!);
    else
      widget.onError("");
  }

  @override
  Widget build(BuildContext context) {
    return FadeHintTextField(
        hintOptions: widget.hintOptions,
        textField: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          onSaved: (newValue) async {
            final result = await isValidPhoneNumber(newValue);
            if (mounted)
              setState(() {
                errorMessage = result;
              });

            if (result == null) {
              widget.onSaved(newValue!);
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

              updateIfValid(value);
            }
          },
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Phone Number",
              labelStyle:
                  TextStyle(backgroundColor: Colors.white, color: Colors.black),
              helperStyle:
                  TextStyle(backgroundColor: Colors.white, fontSize: 14),
              // helperText: "Add manually instead",
              // hintText: "e.g. +1123456789",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: widget.withIcon
                  ? CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg")
                  : null,
              errorText: errorMessage,
              errorStyle: TextStyle(backgroundColor: Colors.white)),
        ));
  }
}
