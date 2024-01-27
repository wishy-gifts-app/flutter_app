import 'package:Wishy/components/address.dart';
import 'package:Wishy/components/addresses_list_widget.dart';
import 'package:Wishy/components/custom_dialog.dart';
import 'package:Wishy/components/location_dialog_form.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Address.dart';
import 'package:Wishy/services/graphql_service.dart';

class AddressesWidget extends StatefulWidget {
  final int userId;
  final Function(Address) onAddressSelected;
  final Follower? defaultUser;

  AddressesWidget({
    Key? key,
    required this.userId,
    required this.onAddressSelected,
    this.defaultUser,
  }) : super(key: key);

  @override
  _AddressesWidgetState createState() => _AddressesWidgetState();
}

class _AddressesWidgetState extends State<AddressesWidget> {
  List<Address>? _addresses;
  int _selectedAddressIndex = 0;
  late GraphQLPaginationService _paginationServices;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    _paginationServices = new GraphQLPaginationService(
      queryName: "getUserAddresses",
      variables: {"limit": 20, "user_id": widget.userId},
    );

    final result = await _paginationServices.run();

    if (mounted && result["data"] != null && result["data"].length > 0) {
      setState(() {
        _addresses = (result["data"] as List<dynamic>)
            .map((item) => Address.fromJson(item))
            .toList();
      });

      widget.onAddressSelected(_addresses![_selectedAddressIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (_addresses == null || _addresses!.isEmpty) ...[
        _buildAddAddressButton()
      ],
      if ((_addresses?.length ?? 0) > 0) _buildAddressDisplay()
    ]);
  }

  Widget _buildAddAddressButton() {
    return Center(
        child: OutlinedButton(
            onPressed: () => _showLocationDialog().then((v) {
                  fetchData();
                  Navigator.of(context).pop();
                }),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_location_outlined, size: 30),
                SizedBox(
                  width: getProportionateScreenWidth(8),
                ),
                const Text('Add Address')
              ],
            )));
  }

  Widget _buildAddressDisplay() {
    final address = _addresses![_selectedAddressIndex];

    return InkWell(
      onTap: () => _showAddressDialog(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AddressTitle(address: address),
                AddressSubtitle(address: address),
              ],
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(15),
          ),
          Icon(Icons.edit, size: 24),
        ],
      ),
    );
  }

  void _showAddressDialog() {
    CustomDialog()
        .show(
      context,
      "Choose your address or add a new one",
      Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                AddressesListWidget(
                  height: 200,
                  addresses: _addresses!,
                  selectedIndex: _selectedAddressIndex,
                  onTap: (idx) {
                    setState(() {
                      _selectedAddressIndex = idx;
                    });
                    widget.onAddressSelected(_addresses![idx]);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                _buildAddAddressButton()
              ])),
    )
        .then((result) {
      if (result != null) {
        setState(() {
          _selectedAddressIndex = 0;
        });

        fetchData();
      }
    });
  }

  Future<dynamic> _showLocationDialog() {
    return showDialog<int>(
        context: context,
        builder: (context) => Dialog.fullscreen(
                child: LocationDialogForm(
              defaultUser: widget.defaultUser,
            )));
  }
}
