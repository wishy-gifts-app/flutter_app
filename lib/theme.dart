import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData theme() {
  ColorScheme colorSchemeLight = ColorScheme(
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    surface: Colors.white,
    surfaceTint: Colors.white,
    background: Colors.white,
    brightness: Brightness.light,
    error: Colors.red,
    onBackground: Colors.black,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    primaryContainer: kPrimaryColor,
    secondaryContainer: kSecondaryColor,
  );

  return ThemeData(
    brightness: Brightness.light,
    colorScheme: colorSchemeLight,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kTextColor,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // colorScheme: ColorScheme.fromSwatch()
    //     .copyWith(secondary: kSecondaryColor, primary: kPrimaryColor),
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then label text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not app layed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge:
        TextStyle(color: kTextColor, fontSize: 15, fontWeight: FontWeight.w500),
    bodyMedium:
        TextStyle(color: kTextColor, fontSize: 14, fontWeight: FontWeight.w500),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    toolbarTextStyle: TextStyle(color: Colors.black),
  );
}
