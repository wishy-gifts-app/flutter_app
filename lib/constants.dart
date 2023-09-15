import 'package:flutter/material.dart';
import 'package:shop_app/size_config.dart';

const variantOptions = [
  "color",
  "size",
  "style",
  "material",
];

const analyticEvents = {
  "START_APP_SESSION": "Start App Session",
  "END_APP_SESSION": "End App Session",
  "APP_PAGE_VIEWED": "App Page Viewed",
  "PHONE_SIGN_IN_SUBMITTED": "Phone Sign In Submitted",
  "OPT_SUBMITTED": "OPT Submitted",
  "CHECKOUT_PRESSED": "Checkout Pressed",
  "COMPLETE_PROFILE_SUBMITTED": "Complete Profile Submitted",
  "PRODUCT_IMAGE_VIEWED": "Product Image Viewed",
  "PRODUCT_VIEWED": "Product Viewed",
  "PRODUCT_DETAILS_PRESSED": "Product Details Pressed",
  "SWIPED_RIGHT": "Swiped Right",
  "SWIPED_LEFT": "Swiped Left",
  "SWIPED_UP": "Swiped Up",
};

const kPrimaryColor = Colors.black;
const kPrimaryLightColor = Colors.grey;
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kInvalidPhoneNumberError = "Invalid phone number";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
