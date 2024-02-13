import 'package:Wishy/components/address.dart';
import 'package:Wishy/components/addresses_list_widget.dart';
import 'package:Wishy/components/custom_dialog.dart';
import 'package:Wishy/components/location_dialog_form.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Wishy/models/Address.dart';
import 'package:provider/provider.dart';

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
  int _selectedAddressIndex = 0;

  @override
  Widget build(BuildContext context) {
    final globalManger = Provider.of<GlobalManager>(context);

    return Column(children: [
      if (globalManger.user?.addresses == null ||
          globalManger.user!.addresses == null ||
          globalManger.user!.addresses!.isEmpty) ...[_buildAddAddressButton()],
      if ((globalManger.user!.addresses?.length ?? 0) > 0)
        _buildAddressDisplay(globalManger.user!.addresses!)
    ]);
  }

  Widget _buildAddAddressButton() {
    return Center(
        child: OutlinedButton(
            onPressed: () => _showLocationDialog(),
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

  Widget _buildAddressDisplay(List<Address> addresses) {
    return InkWell(
      onTap: () => _showAddressDialog(addresses),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AddressTitle(address: addresses[_selectedAddressIndex]),
                AddressSubtitle(address: addresses[_selectedAddressIndex]),
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

  void _showAddressDialog(List<Address> addresses) {
    CustomDialog().show(
      context,
      "Choose your address or add a new one",
      Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                AddressesListWidget(
                  height: 250,
                  addresses: addresses,
                  selectedIndex: this._selectedAddressIndex,
                  onTap: (idx) {
                    setState(() {
                      _selectedAddressIndex = idx;
                    });

                    widget.onAddressSelected(addresses[idx]);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(25),
                ),
                _buildAddAddressButton()
              ])),
    );
  }

  Future<dynamic> _showLocationDialog() {
    return showDialog<int>(
        context: context,
        builder: (context) => Dialog.fullscreen(
                child: LocationDialogForm(
              afterAddressAdded: (address) {
                setState(() {
                  _selectedAddressIndex = 0;
                });
                widget.onAddressSelected(address);
                Navigator.of(context).pop();
              },
              defaultUser: widget.defaultUser,
            )));
  }
}
