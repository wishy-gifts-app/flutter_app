import 'package:Wishy/components/addresses_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/global_manager.dart';
import 'package:provider/provider.dart';

class PersonalInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalManger = Provider.of<GlobalManager>(context);

    if (globalManger.user == null)
      return Center(child: CircularProgressIndicator());

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text("Personal Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("Name: ${GlobalManager().user?.name ?? ''}"),
        SizedBox(height: 5),
        Text("Email: ${GlobalManager().user?.email ?? ''}"),
        SizedBox(height: 5),
        Text("Phone: ${GlobalManager().user?.phoneNumber ?? ''}"),
        SizedBox(height: 20),
        Text("Addresses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        AddressesListWidget(
          height: 255,
          addresses: GlobalManager().user?.addresses ?? [],
        ),
      ],
    );
  }
}
