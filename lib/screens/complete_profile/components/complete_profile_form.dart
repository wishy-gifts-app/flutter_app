import 'package:Wishy/utils/contacts.dart';
import 'package:Wishy/utils/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/custom_surfix_icon.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/screens/login_success/login_success_screen.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/utils/analytics.dart';
import 'package:email_validator/email_validator.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  String? _fullName;
  String? _email;
  bool _giveNotificationPermission = true;
  bool _loading = false;

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });

      final email = _fullName?.trim();
      final fullName = _fullName?.trim();
      try {
        Map<String, dynamic> notificationParams = {};
        if (_giveNotificationPermission &&
            GlobalManager().notificationAvailable == null) {
          final result = await requestNotificationPermission();

          notificationParams = {
            "notification_available": result["available"],
            "fcm_token": result["fcmToken"]
          };
        }

        await graphQLQueryHandler("updateUserById", {
          "email": email,
          "name": fullName,
          "id": GlobalManager().userId,
          ...notificationParams
        });
        await GlobalManager().setParams(
            newProfileCompleted: true,
            newUsername: fullName,
            newNotificationAvailable:
                notificationParams["notification_available"]);
        AnalyticsService.trackEvent(
            analyticEvents["COMPLETE_PROFILE_SUBMITTED"]!);

        AnalyticsService.setUserProfile(GlobalManager().userId!, {
          "Email": email,
          "Name": fullName,
          "Notification Permission": _giveNotificationPermission
        });
        Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      } catch (error) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error completing profile. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(
              height: getProportionateScreenHeight(
                  GlobalManager().notificationAvailable == true ? 80 : 50)),
          // CheckboxListTile(
          //   title: Text(
          //     "Give permission to get contacts for matching with them",
          //     style: TextStyle(fontSize: 12),
          //   ),
          //   value: _givePermission,
          //   onChanged: (bool? value) {
          //     setState(() {
          //       _givePermission = value!;
          //     });
          //   },
          //   controlAffinity: ListTileControlAffinity.leading,
          // ),
          if (GlobalManager().notificationAvailable == null) ...[
            CheckboxListTile(
              title: Text(
                "Get Personalized Alerts: Receive notifications for customized product recommendations",
                style: TextStyle(fontSize: 12),
              ),
              value: _giveNotificationPermission,
              onChanged: (bool? value) {
                setState(() {
                  _giveNotificationPermission = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
          ],
          DefaultButton(
            text: "continue",
            press: onSubmit,
            loading: _loading,
          ),
        ],
      ),
    );
  }

  // TextFormField buildBirthdayFormField() {
  //   return TextFormField(
  //     controller: _dateController,
  //     onTap: () {
  //       _selectDate(context);
  //     },
  //     onSaved: (newValue) {
  //       birthday = DateTime.tryParse(newValue ?? '');
  //     },
  //     validator: (value) {
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Birthday",
  //       hintText: "Enter your birthday",
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Calendar.svg"),
  //     ),
  //     readOnly: true,
  //   );
  // }

  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: birthday ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );

  //   if (picked != null && picked != birthday) {
  //     setState(() {
  //       birthday = picked;
  //       _dateController.text = "${picked.toLocal()}".split(' ')[0];
  //     });
  //   }
  // }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      onSaved: (newValue) => _fullName = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty) {
          return kNameNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Enter your full name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      onSaved: (newValue) => _email = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty || !EmailValidator.validate(value.trim())) {
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
