import 'package:Wishy/utils/contacts.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/components/custom_surfix_icon.dart';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/form_error.dart';
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
  String? fullName;
  String? email;
  bool _givePermission = true;

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        if (_givePermission) {
          await fetchContacts();
        }

        await graphQLQueryHandler("updateUserById",
            {"email": email, "name": fullName, "id": GlobalManager().userId});
        await GlobalManager()
            .setParams(newProfileCompleted: true, newUsername: fullName);
        AnalyticsService.trackEvent(
            analyticEvents["COMPLETE_PROFILE_SUBMITTED"]!);

        AnalyticsService.setUserProfile(GlobalManager().userId!, {
          "Email": email,
          "Name": fullName,
        });
        Navigator.pushNamed(context, LoginSuccessScreen.routeName);
      } catch (error) {
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
          SizedBox(height: getProportionateScreenHeight(30)),
          CheckboxListTile(
            title: Text(
              "Give permission to get contacts for matching with them",
              style: TextStyle(fontSize: 12),
            ),
            value: _givePermission,
            onChanged: (bool? value) {
              setState(() {
                _givePermission = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(text: "continue", press: onSubmit),
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
      onSaved: (newValue) => fullName = newValue,
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
      onSaved: (newValue) => email = newValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.isEmpty || !EmailValidator.validate(value)) {
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
