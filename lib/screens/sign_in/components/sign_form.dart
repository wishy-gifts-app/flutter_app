import 'dart:async';
import 'package:Wishy/components/phone_number_field.dart';
import 'package:Wishy/components/privacy.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/utils/user_details.dart';
import 'package:Wishy/utils/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/otp/otp_screen.dart';
import 'package:Wishy/services/opt_services.dart';
import 'package:flutter/gestures.dart';
import 'package:Wishy/utils/analytics.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => new _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = new GlobalKey<FormState>();
  final List<String?> errors = [];
  String? phoneNumber = "";
  final authServices = AuthServices();
  int selectedIcon = 1;
  bool _pressed = false;
  Completer<bool>? _phoneValidationCompleter;
  final TextEditingController _phoneController = TextEditingController();

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

  Future<void> skipSignIn() async {
    if (_pressed) return;

    _pressed = true;
    if (GlobalManager().token != null) {
      RouterUtils.routeToHomePage();
      return;
    }

    try {
      final result = await authServices.guestSignInService();

      await GlobalManager().setParams(
        newToken: result.token,
        newUserId: result.userId,
        newSignedIn: false,
      );
      AnalyticsService.registerSuperProperties({"User Id": result.userId});
      setUserDetails();

      if (mounted) {
        RouterUtils.routeToHomePage();
      }
    } catch (error) {
      if (mounted) print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Sorry, we're unable to access the products page. Please retry shortly.")),
      );
    }

    _pressed = false;
  }

  void _onPhoneChanged(String? phone) {
    setState(() {
      phoneNumber = phone;
    });

    if (_phoneValidationCompleter != null &&
        !_phoneValidationCompleter!.isCompleted)
      _phoneValidationCompleter!.complete(true);
  }

  Future<void> sendOPTNumber() async {
    if (_pressed) return;

    _pressed = true;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _phoneValidationCompleter = Completer<bool>();
      await _phoneValidationCompleter!.future;

      if (phoneNumber != null) {
        try {
          removeError(error: kInvalidPhoneNumberError);
          authServices.sendOTPService(phoneNumber!);
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
    }

    _pressed = false;
  }

  Future<void> _notificationSignIn() async {
    try {
      final result = await authServices.notificationSignInService();

      await GlobalManager().setParams(
        newToken: result.token,
        newUserId: result.userId,
        newSignedIn: true,
      );

      AnalyticsService.registerSuperProperties({"User Id": result.userId});
      setUserDetails();

      if (mounted) {
        RouterUtils.routeToHomePage(skipProfileCompleted: true);
      }
    } catch (error) {
      if (mounted) print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Sorry, we're unable to access the products page. Please retry shortly.")),
      );
    }
  }

  @override
  void initState() {
    if (GlobalManager().signedIn) {
      Navigator.pushNamed(
        context,
        GlobalManager().profileCompleted == true
            ? HomeScreen.routeName
            : CompleteProfileScreen.routeName,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalManager().notificationToken != null)
      return Form(
        key: _formKey,
        child: Column(children: [
          SizedBox(height: getProportionateScreenHeight(90)),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: <TextSpan>[
                TextSpan(
                  text: "By continuing you confirm that you agree with our ",
                ),
                TextSpan(
                  text: "Privacy Terms",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Dialog.fullscreen(child: PrivacyWebView());
                        },
                      );
                    },
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          DefaultButton(
              eventName: analyticEvents["NOTIFICATION_SIGN_IN"]!,
              eventData: {
                "Notification token": GlobalManager().notificationToken
              },
              text: "Start Now",
              press: _notificationSignIn),
        ]),
      );

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
              PhoneNumberField(
                hintOptions: ["Add your phone number", "E.g. +1 212-555-1234"],
                controller: _phoneController,
                onSaved: _onPhoneChanged,
                onError: (String error) => _onPhoneChanged(null),
              ),
              SizedBox(height: getProportionateScreenHeight(5)),
              Text(
                "An OTP code will be sent via SMS to verify your phone number.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                  height: getProportionateScreenHeight(
                      GlobalManager().token == null ? 55 : 70)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall,
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "By continuing you confirm that you agree with our ",
                    ),
                    TextSpan(
                      text: "Privacy Terms",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Dialog.fullscreen(child: PrivacyWebView());
                            },
                          );
                        },
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              DefaultButton(
                eventName: analyticEvents["PHONE_SIGN_IN_SUBMITTED"]!,
                text: "Start Now",
                press: () async {
                  FocusScope.of(context).unfocus();
                  await sendOPTNumber();
                },
              ),
              if (GlobalManager().token == null) ...[
                SizedBox(height: getProportionateScreenHeight(20)),
                DefaultButton(
                    backgroundColor: Colors.black54,
                    eventName: analyticEvents["SKIP_SIGN_IN"]!,
                    eventData: {
                      "Related To Product Id":
                          GlobalManager().signInRelatedProductId
                    },
                    text: "Explore as Guest",
                    press: skipSignIn)
              ],
            ])),
      ]),
    );
  }
}
