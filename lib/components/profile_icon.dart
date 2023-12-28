import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Wishy/global_manager.dart';

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/consultant_profile.png"),
        ),
        Positioned(
          right: -16,
          bottom: 0,
          child: SizedBox(
            height: 46,
            width: 46,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFF5F6F9),
              ),
              onPressed: () {},
              child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
            ),
          ),
        )
      ],
    );
  }
}
