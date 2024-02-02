import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/UserDetails.dart';
import 'package:Wishy/services/graphql_service.dart';

Future<void> setUserDetails() => graphQLQueryHandler(
            "getUserDetailsById", {"user_id": GlobalManager().userId})
        .then((userDetails) {
      if (userDetails != null)
        GlobalManager().setUser(UserDetails.fromJson(userDetails));
    });
