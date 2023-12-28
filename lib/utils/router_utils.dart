import 'package:Wishy/global_manager.dart';
import 'package:Wishy/main.dart';
import 'package:Wishy/screens/requests/requests_screen.dart';
import 'package:Wishy/screens/sign_in/sign_in_screen.dart';
import 'package:Wishy/screens/complete_profile/complete_profile_screen.dart';
import 'package:Wishy/screens/home/home_screen.dart';

class RouterUtils {
  static void routeToHomePage({bool skipProfileCompleted = false}) {
    if (GlobalManager().token == null) {
      navigatorKey.currentState?.pushReplacementNamed(
        SignInScreen.routeName,
      );
    } else if (GlobalManager().profileCompleted != true &&
        GlobalManager().signedIn == true &&
        !skipProfileCompleted) {
      navigatorKey.currentState
          ?.pushReplacementNamed(CompleteProfileScreen.routeName);
    } else {
      if (GlobalManager().navigateToRequest) {
        GlobalManager().setNavigateToRequest(false);
        navigatorKey.currentState
            ?.pushReplacementNamed(RequestsScreen.routeName);
        return;
      }

      navigatorKey.currentState?.pushReplacementNamed(HomeScreen.routeName);
    }
  }
}
