import 'dart:async';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/search_user.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class InviteCard extends StatefulWidget {
  final Function(Map<String, dynamic>, String) onSelect;
  final String CTA;

  InviteCard({
    Key? key,
    required this.onSelect,
    required this.CTA,
  }) : super(key: key);

  @override
  _InviteCardState createState() => _InviteCardState();
}

class _InviteCardState extends State<InviteCard> {
  final _formKey = GlobalKey<FormState>();
  Completer<bool>? _phoneValidationCompleter;
  String? _name;
  String? _phone;
  int? _userId;
  bool? _isActiveUser;

  void _handleNameChanged(String? name) {
    setState(() => _name = name);
  }

  void _handlePhoneChanged(String? phone) {
    setState(() => _phone = phone);
    _phoneValidationCompleter!.complete(true);
  }

  void _handleUserSelected(int? userId, bool? isActiveUser) {
    setState(() {
      _userId = userId;
      _isActiveUser = isActiveUser;
    });
  }

  void _handleSendInvitation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_userId == null) {
        _phoneValidationCompleter = Completer<bool>();
        await _phoneValidationCompleter!.future;
      }

      if (_userId != null || (_name != null && _phone != null)) {
        widget.onSelect(
            {"name": _name, "userId": _userId, "phone": _phone},
            this._isActiveUser == true
                ? "Fetching ${_name}'s Favorite Picks..."
                : "Inviting ${_name} to Share...");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(30)),
            SearchUserWidget(
                onNameChanged: _handleNameChanged,
                onPhoneChanged: _handlePhoneChanged,
                onUserSelected: _handleUserSelected,
                withIcon: false),
            SizedBox(height: getProportionateScreenHeight(25)),
            DefaultButton(
              press: _handleSendInvitation,
              text: widget.CTA,
            ),
          ],
        ));
  }
}
