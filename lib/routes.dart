import 'package:flutter/widgets.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/checkout/checkout_screen.dart';
import 'package:shop_app/screens/complete_profile/complete_profile_screen.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/screens/matches/matches_screen.dart';
import 'package:shop_app/screens/otp/otp_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/root_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/likes/likes_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return OtpScreen(phoneNumber: args['phoneNumber'] as String);
  },
  CheckoutScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return CheckoutScreen(
        variant: args['variant'] as Variant, orderId: args['orderId'] as int);
  },
  HomeScreen.routeName: (context) => HomeScreen(),
  LikesScreen.routeName: (context) => LikesScreen(),
  MatchesScreen.routeName: (context) => MatchesScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  RootScreen.routeName: (context) => RootScreen(),
};
