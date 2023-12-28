import 'package:Wishy/global_manager.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/size_config.dart';

import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text("Complete Profile", style: headingStyle),
                if (GlobalManager().signInRelatedProductId == null)
                  Text(
                    "Complete your personal details",
                    textAlign: TextAlign.center,
                  ),
                if (GlobalManager().signInRelatedProductId != null)
                  Text(
                    "Complete your personal details to finalize your action",
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                CompleteProfileForm(),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
