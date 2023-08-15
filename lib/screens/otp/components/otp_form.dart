import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/services/opt_services.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

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
  bool? completedProfile = GlobalManager().profileCompleted;
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
            // press: handleOtpSubmission,
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
          newProfileCompleted: result.profileCompleted,
          newUserId: result.userId);

      if (mounted) {
        Navigator.pushNamed(
          context,
          result.profileCompleted == true
              ? HomeScreen.routeName
              : CompleteProfileScreen.routeName,
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying OTP. Please try again.')),
      );
    }
  }
}
