import 'package:Wishy/components/phone_number_field.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchContactWidget extends StatefulWidget {
  final Function(int? userId, bool? isActiveUser) onUserSelected;
  final Function(String?) onNameChanged;
  final Function(String?) onPhoneChanged;
  final bool withIcon;

  SearchContactWidget({
    required this.onUserSelected,
    required this.onNameChanged,
    required this.onPhoneChanged,
    this.withIcon = true,
  });

  @override
  _SearchContactWidgetState createState() => _SearchContactWidgetState();
}

class _SearchContactWidgetState extends State<SearchContactWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  int? _selectedUser;
  bool _isActiveUser = false;

  void afterContactSelect() async {
    final result = await graphQLQueryHandler(
        "isPhoneExists", {"phone_number": _phoneController.text});

    if (result["user_id"] != null) {
      setState(() {
        _isActiveUser = result["is_active_user"];
      });

      widget.onUserSelected(result["user_id"], _isActiveUser);
    }

    widget.onNameChanged(_phoneController.text);
    widget.onPhoneChanged(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        _buildNameInput(),
        SizedBox(height: getProportionateScreenHeight(10)),
        _buildPhoneInput(),
      ],
    );
  }

  Widget _buildNameInput() {
    return TypeAheadFormField(
      hideOnEmpty: true,
      hideSuggestionsOnKeyboardHide: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      direction: AxisDirection.up,
      onSaved: (_) => {widget.onNameChanged(_nameController.text)},
      textFieldConfiguration: TextFieldConfiguration(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: "Search in contacts...",
          labelStyle:
              TextStyle(backgroundColor: Colors.white, color: Colors.black),
          labelText: 'Name',
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern.length < 1) {
          return [];
        }
        try {
          final result = await Contacts.searchContacts(pattern);

          return result == null ? [] : result;
        } catch (error) {
          print(error);

          return [];
        }
      },
      itemBuilder: (context, suggestion) {
        final contact = suggestion as Follower;
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
        );
      },
      onSuggestionSelected: (suggestion) {
        final contact = suggestion as Follower;
        setState(() {
          _nameController.text = contact.name;
          _phoneController.text = contact.phoneNumber;
        });
      },
    );
  }

  Widget _buildPhoneInput() {
    return PhoneNumberField(
      controller: _phoneController,
      onSaved: widget.onPhoneChanged,
      onError: (String error) => widget.onPhoneChanged(null),
      withIcon: widget.withIcon,
    );
  }
}
