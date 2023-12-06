import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/services/opt_services.dart';
import 'package:otp_text_field/otp_field.dart';
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
  final otpServices = OTPServices();
  String otpValue = "";

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          OTPTextField(
            length: 4,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 50,
            style: TextStyle(fontSize: 17),
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
            text: "Continue",
            press: handleOtpSubmission,
          )
        ],
      ),
    );
  }

  Future<void> handleOtpSubmission() async {
    try {
      final result =
          await otpServices.verifyOTPService(widget.phoneNumber, otpValue);

      await GlobalManager().setParams(
          newToken: result.token,
          newUserId: result.userId,
          newUsername: result.username);
      AnalyticsService.registerSuperProperties({"User Id": result.userId});

      AnalyticsService.trackEvent(
        analyticEvents["OPT_SUBMITTED"]!,
      );

      if (mounted) {
        //TODO fix this if that start to use
        // RouterUtils.routeToHomePage(
        //     context, result.profileCompleted, result.token);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }
  }
}
