import 'package:flutter/material.dart';
import 'package:shop_app/components/location_dialog_form.dart';
import 'package:shop_app/size_config.dart';

class BuyForYourself extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        Text(
          "You haven't added an address yet. Please provide one.",
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: Icon(
            Icons.add_location,
            size: 50,
          ),
          tooltip: "Add address",
          onPressed: () {
            // Navigator.of(context).push(new MaterialPageRoute<Null>(
            //     builder: (BuildContext context) {
            //       return new LocationDialogForm();
            //     },
            //     fullscreenDialog: true));

            showDialog(
              context: context,
              builder: (context) =>
                  Dialog.fullscreen(child: LocationDialogForm()),
            );
          },
        ),
      ],
    );
  }
}
