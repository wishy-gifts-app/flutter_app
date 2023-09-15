import 'package:flutter/material.dart';
import 'package:shop_app/global_manager.dart';
import 'package:shop_app/models/Address.dart';
import 'package:shop_app/models/User.dart';
import 'package:shop_app/services/graphql_service.dart';

class PersonalInfoTab extends StatefulWidget {
  @override
  _PersonalInfoTabState createState() => _PersonalInfoTabState();
}

class _PersonalInfoTabState extends State<PersonalInfoTab> {
  List<Address>? _addresses;
  User? _userData;

  @override
  void initState() {
    super.initState();
    _initializeData();
    fetchPersonalInfo();
  }

  Future<void> _initializeData() async {
    final result = await GraphQLService()
        .queryHandler("getUserAddresses", {"limit": 20}, withPagination: true);

    final data = await fetchData(result);
    if (mounted) {
      setState(() {
        _addresses = data;
      });
    }
  }

  Future<List<Address>?> fetchData(
      Map<String, dynamic>? paginationServices) async {
    final formatResponse = (dynamic result) => (result as List<dynamic>)
        .map((item) => Address.fromJson(item))
        .toList();

    final nextPageData = await paginationServices!["nextPage"]();
    return nextPageData != null ? formatResponse(nextPageData) : null;
  }

  Future<void> fetchPersonalInfo() async {
    final result = await GraphQLService()
        .queryHandler("userById", {"id": GlobalManager().userId});

    if (mounted) {
      setState(() {
        _userData = User.fromJson(result);
      });
    }

    print(_userData);
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
