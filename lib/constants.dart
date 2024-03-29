import 'package:flutter/material.dart';
import 'package:Wishy/size_config.dart';

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
  "SWIPED_LEFT": "Start Request",
  "START_REQUEST": "Swiped Up",
  "SHOW_MORE_PRODUCT_DESCRIPTION": "Show More Product Description",
  "INSTAGRAM_AUTH_SUBMITTED": "Instagram Auth Submitted",
  "ADDRESS_ADDED": "Address Added",
  "ADDRESS_SELECTED": "Address Selected",
  "PAY_PRESSED": "Pay Pressed",
  "NEW_PURCHASE": "New Purchase",
  "PRODUCT_REQUESTED": "Product Requested",
  "REQUEST_VARIANT_PICKED": "Request Variant Picked",
  "FILTER_PRODUCTS_FEED": "Filter Product Feed",
  "SUPPORT_PRESSED": "Support Pressed",
  "REQUEST_REMOVED": "Request Removed",
  "PAGE_OPENED": "Page Opened",
  "PROFILE_TAB_PRESSED": "Profile Tab Pressed",
  "SKIP_SIGN_IN": "Skip Sign In",
  "NOTIFICATION_SIGN_IN": "Notification Sign In",
  "INTERACTIVE_CARD_HANDLED": "Interactive Card Handled",
  "INTERACTIVE_CARD_DISPLAYED": "Interactive Card Displayed",
  "REWARD_CTA_PRESSED": "Reward CTA Pressed",
};

const kPrimaryColor = Colors.black;
const kAlertColor = Color.fromRGBO(245, 124, 0, 1);
//  Color(0xFF1B5E20);
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
final defaultButtonTextStyle = TextStyle(
  fontSize: getProportionateScreenWidth(18),
  color: Colors.white,
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
const String kUserNameNullError = "Please Enter a user name";
const String kReasonNullError = "Please Enter the reason";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kInvalidPhoneNumberError = "Enter phone with international prefix";
const marketDetails = {
  "symbol": "\$",
  "google_country": "us",
  "country": "USA",
  "country_full_name": "United States",
  "currency": "usd",
  "short": "USD"
};
const String privacyURL = "https://www.wishy.store/privacy";
const String refoundTermsURL = "https://www.wishy.store/refound-terms";
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
