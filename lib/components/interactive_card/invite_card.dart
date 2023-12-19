import 'dart:async';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/search_contact.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class InviteCard extends StatefulWidget {
  final Function(Map<String, dynamic>, String) onSelect;
  final String CTA;
  final String question;

  InviteCard({
    Key? key,
    required this.onSelect,
    required this.CTA,
    required this.question,
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

      if (_userId != null || _phone != null) {
        widget.onSelect(
            {"name": _name, "user_id": _userId, "phone_number": _phone},
            this._isActiveUser == true
                ? "Fetching ${_name}'s Favorite Picks..."
                : "Inviting ${_name} to Share...");
      }
    }
  }

  void _handleDisconnect() async {
    widget.onSelect({"disconnect": true}, "Disconnecting...");
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalManager().connectUser != null)
      return Column(
        children: [
          RoundedBackgroundText(
            '${GlobalManager().connectUser} is now connected for gifting. Browse their wishlist to find the perfect gift!',
            backgroundColor: Colors.black.withOpacity(0.5),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              wordSpacing: 1,
              height: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(50)),
          DefaultButton(
            press: _handleDisconnect,
            text: "Disconnect",
          ),
        ],
      );

    return Form(
        key: _formKey,
        child: Column(
          children: [
            RoundedBackgroundText(
              widget.question,
              backgroundColor: Colors.black.withOpacity(0.5),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                wordSpacing: 1,
                height: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            SearchContactWidget(
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
