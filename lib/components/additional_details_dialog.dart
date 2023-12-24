import 'package:flutter/material.dart';
import 'package:Wishy/components/default_button.dart';

class AdditionalDetailsDialog extends StatelessWidget {
  final String description;

  const AdditionalDetailsDialog({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Additional Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(description),
            SizedBox(height: 20),
            DefaultButton(
              loading: false,
              text: "Back",
              press: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
