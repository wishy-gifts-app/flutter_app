import 'package:flutter/material.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/models/User.dart';
import 'package:Wishy/services/graphql_service.dart';

class PersonalInfoTab extends StatefulWidget {
  @override
  _PersonalInfoTabState createState() => _PersonalInfoTabState();
}

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  List<Address>? _addresses;
  User? _userData;
  GraphQLPaginationService _paginationServices = new GraphQLPaginationService(
    queryName: "getUserAddresses",
    variables: {"limit": 20},
  );

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchPersonalInfo();
  }

  Future<void> fetchData() async {
    final result = await _paginationServices.run();

    if (mounted && result["data"] != null) {
      setState(() {
        _addresses = (result["data"] as List<dynamic>)
            .map((item) => Address.fromJson(item))
            .toList();
      });
    }
  }

  Future<void> fetchPersonalInfo() async {
    final result =
        await graphQLQueryHandler("userById", {"id": GlobalManager().userId});

    if (mounted) {
      setState(() {
        _userData = User.fromJson(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        Text("Personal Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("Name: ${_userData?.name ?? ''}"),
        SizedBox(height: 5),
        Text("Email: ${_userData?.email ?? ''}"),
        SizedBox(height: 5),
        Text("Phone: ${_userData?.phoneNumber ?? ''}"),
        SizedBox(height: 20),
        Text("Addresses",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        if (_addresses != null && _addresses!.length > 0)
          ..._addresses!.map((address) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(address.country +
                  ", " +
                  address.city +
                  ", " +
                  address.streetAddress +
                  " " +
                  address.streetNumber),
            );
          }).toList(),
        if (_addresses == null || _addresses!.isEmpty)
          Text("You haven't added an address yet."),
      ],
    );
  }
}
