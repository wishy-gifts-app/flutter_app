import 'package:flutter/material.dart';

class PersonalInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is just a dummy content. Fetch and display actual user data here.
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text("Name: [User's Name]"),
        ),
        ListTile(
          title: Text("Address: [User's Address]"),
        ),
        ListTile(
          title: Text("Phone: [User's Phone]"),
        ),
      ],
    );
  }
}
