import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/services/graphql_service.dart';
import 'package:shop_app/utils/analytics.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? fullName;
  DateTime? birthday;
  final TextEditingController _dateController = TextEditingController();

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

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await GraphQLService().queryHandler("updateUserById", {
          "birthday": birthday,
          "full_name": fullName,
          "id": GlobalManager().userId
        });
        await GlobalManager().setParams(newProfileCompleted: true);
        AnalyticsService.trackEvent(
            analyticEvents["COMPLETE_PROFILE_SUBMITTED"]!);

        AnalyticsService.setUserProfile(GlobalManager().userId!, {
          "Birthday": birthday,
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
          buildBirthdayFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(text: "continue", press: onSubmit),
        ],
      ),
    );
  }

  TextFormField buildBirthdayFormField() {
    return TextFormField(
      controller: _dateController,
      onTap: () {
        _selectDate(context);
      },
      onSaved: (newValue) {
        birthday = DateTime.tryParse(newValue ?? '');
      },
      validator: (value) {
        return null;
      },
      decoration: InputDecoration(
        labelText: "Birthday",
        hintText: "Enter your birthday",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Calendar.svg"),
      ),
      readOnly: true,
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != birthday) {
      setState(() {
        birthday = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      onSaved: (newValue) => fullName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNameNullError);
          return "";
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
}
