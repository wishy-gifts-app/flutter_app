import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:Wishy/models/Product.dart';
import 'package:Wishy/screens/checkout/checkout_screen.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/details/details_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';
import 'package:Wishy/screens/login_success/login_success_screen.dart';
import 'package:Wishy/screens/matches/matches_screen.dart';
import 'package:Wishy/screens/otp/otp_screen.dart';
import 'package:Wishy/screens/profile/profile_screen.dart';
import 'package:Wishy/screens/root_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:Wishy/screens/likes/likes_screen.dart';

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
        variant: args['variant'] as Variant,
        productId: args['productId'] as int);
  },
  HomeScreen.routeName: (context) => HomeScreen(),
  LikesScreen.routeName: (context) => LikesScreen(),
  MatchesScreen.routeName: (context) => MatchesScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  RequestsScreen.routeName: (context) => RequestsScreen(),
  RootScreen.routeName: (context) => RootScreen(),
};
