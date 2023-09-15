import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/global_manager.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Initicon(
        text: GlobalManager().username ?? "",
        elevation: 4,
      ),
      // Stack(
      //   fit: StackFit.expand,
      //   clipBehavior: Clip.none,
      //   children: [
      //     CircleAvatar(
      //       backgroundImage: AssetImage("assets/images/Profile Image.png"),
      //     ),
      //     Positioned(
      //       right: -16,
      //       bottom: 0,
      //       child: SizedBox(
      //         height: 46,
      //         width: 46,
      //         child: TextButton(
      //           style: TextButton.styleFrom(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(50),
      //               side: BorderSide(color: Colors.white),
      //             ),
      //             foregroundColor: Colors.white,
      //             backgroundColor: Color(0xFFF5F6F9),
      //           ),
      //           onPressed: () {},
      //           child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}
