import 'package:Wishy/utils/user_details.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/opt_services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:Wishy/utils/router_utils.dart';

class OtpForm extends StatefulWidget {
  final String phoneNumber;

  const OtpForm({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final otpServices = AuthServices();
  String otpValue = "";
  bool? completedProfile = GlobalManager().profileCompleted;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          OTPTextField(
            onChanged: (v) => {},
            length: 4,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 50,
            otpFieldStyle: OtpFieldStyle(focusBorderColor: kPrimaryColor),
            style: TextStyle(fontSize: 17, color: kPrimaryColor),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) async {
              setState(() {
                otpValue = pin;
              });
              await handleOtpSubmission();
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            isPressed: _isPressed,
            text: "Continue",
            press: handleOtpSubmission,
          )
        ],
      ),
    );
  }

  Future<void> handleOtpSubmission() async {
    if (_isPressed) return;

    setState(() {
      _isPressed = true;
    });
    try {
      final result =
          await otpServices.verifyOTPService(widget.phoneNumber, otpValue);

      await GlobalManager().setParams(
        newToken: result.token,
        newUserId: result.userId,
        newProfileCompleted: result.profileCompleted,
        newNotificationAvailable: result.notificationAvailable,
        newSignedIn: true,
      );

      if (result.profileCompleted) {
        GlobalManager().setShowAnimation(false);
      }

      AnalyticsService.registerSuperProperties({"User Id": result.userId});
      AnalyticsService.setUserProfile(
          GlobalManager().userId!, {"Notification Available": false});

      AnalyticsService.trackEvent(
        analyticEvents["OPT_SUBMITTED"]!,
      );

      if (result.profileCompleted) {
        setUserDetails();
      }

      if (mounted) {
        RouterUtils.routeToHomePage();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }

    _isPressed = false;
  }
}
