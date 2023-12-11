import 'dart:async';

import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/search_user.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';

class SearchUserInput extends StatefulWidget {
  final Function(Map<String, dynamic>) onSelect;
  final String cta;

  SearchUserInput({
    Key? key,
    required this.onSelect,
    required this.cta,
  }) : super(key: key);

  @override
  _SearchUserInputState createState() => _SearchUserInputState();
}

class _SearchUserInputState extends State<SearchUserInput> {
  final _formKey = GlobalKey<FormState>();
  Completer<bool>? _phoneValidationCompleter;

  String? _name;
  String? _phone;
  int? _userId;

  void _handleNameChanged(String? name) {
    setState(() => _name = name);
  }

  void _handlePhoneChanged(String? phone) {
    setState(() => _phone = phone);
  }

  void _handleUserSelected(int? userId) {
    setState(() => _userId = userId);
  }

  void _handleSendInvitation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_userId == null) {
        _phoneValidationCompleter = Completer<bool>();
        await _phoneValidationCompleter!.future;
      }

      if (_userId != null || (_name != null && _phone != null)) {
        widget.onSelect({"name": _name, "userId": _userId, "phone": _phone});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 230,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SearchUserWidget(
                    onNameChanged: _handleNameChanged,
                    onPhoneChanged: _handlePhoneChanged,
                    onUserSelected: _handleUserSelected,
                    withIcon: false),
                SizedBox(height: 10),
                DefaultButton(
                  press: _handleSendInvitation,
                  text: widget.cta,
                ),
              ],
            )));
  }
}
