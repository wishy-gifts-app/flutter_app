import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:Wishy/components/custom_surfix_icon.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/form_error.dart';
import 'package:Wishy/screens/otp/otp_screen.dart';
import 'package:Wishy/services/opt_services.dart';

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
  int selectedIcon = 1;

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

  Future<void> sendOPTNumber() async {
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
      otpServices.sendOTPService(phoneNumber);
      Navigator.pushNamed(
        context,
        OtpScreen.routeName,
        arguments: {'phoneNumber': phoneNumber},
      );
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //   InkWell(
        //     onTap: () async {
        //       setState(() {
        //         selectedIcon = 0;
        //       });

        //       try {
        //         final result = await getInstagramToken(context);

        //         await GlobalManager().setParams(
        //             newToken: result.token,
        //             newProfileCompleted: result.profileCompleted,
        //             newUserId: result.userId);
        //         AnalyticsService.registerSuperProperties(
        //             {"User Id": result.userId});

        //         AnalyticsService.trackEvent(
        //           analyticEvents["INSTAGRAM_AUTH_SUBMITTED"]!,
        //         );

        //         if (mounted) {
        //           RouterUtils.routeToHomePage(
        //             context,
        //             result.profileCompleted,
        //           );
        //         }
        //       } catch (error) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //               content: Text(
        //                   'Failed to sign in with Instagram. Please try again.')),
        //         );
        //       }
        //     },
        //     child: SvgPicture.asset(
        //       'assets/icons/instagram.svg',
        //       height: 50.0,
        //     ),
        //   ),
        //   InkWell(
        //     onTap: () async {
        //       setState(() {
        //         selectedIcon = 1;
        //       });
        //     },
        //     child: SvgPicture.asset(
        //       'assets/icons/sms-icon.svg',
        //       height: 50.0,
        //     ),
        //   )
        // ]),
        // SizedBox(height: getProportionateScreenHeight(50)),
        Visibility(
          visible: selectedIcon == 0,
          child: Text(
            'Continue with Instagram to get matches with your followings.',
            textAlign: TextAlign.center,
          ),
        ),
        Visibility(
            visible: selectedIcon == 1,
            child: Column(children: [
              buildPhoneNumberFormField(),
              SizedBox(height: getProportionateScreenHeight(30)),
              FormError(errors: errors),
              SizedBox(height: getProportionateScreenHeight(40)),
              DefaultButton(
                eventName: analyticEvents["PHONE_SIGN_IN_SUBMITTED"]!,
                text: "continue",
                press: () async {
                  FocusScope.of(context).unfocus();
                  await sendOPTNumber();
                },
              ),
            ])),
      ]),
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
