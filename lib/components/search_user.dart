import 'package:Wishy/components/phone_number_field.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchUserWidget extends StatefulWidget {
  final Function(int?) onUserSelected;
  final Function(String?) onNameChanged;
  final Function(String?) onPhoneChanged;
  final bool withIcon;

  SearchUserWidget(
      {required this.onUserSelected,
      required this.onNameChanged,
      required this.onPhoneChanged,
      this.withIcon = true});

  @override
  _SearchUserWidgetState createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends State<SearchUserWidget> {
  final TextEditingController _typeAheadController = TextEditingController();
  int? _selectedUser;
  bool _showPhoneField = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        TypeAheadFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: (newValue) => {
            if (_showPhoneField)
              widget.onNameChanged(newValue)
            else
              widget.onUserSelected(_selectedUser)
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kUserNameNullError;
            }
            return null;
          },
          textFieldConfiguration: TextFieldConfiguration(
            onChanged: (value) {
              _showPhoneField = true;
            },
            controller: _typeAheadController,
            decoration: InputDecoration(labelText: 'Search User'),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.length < 2) {
              return [];
            }
            final result = await graphQLQueryHandler(
                "searchForFollower", {"limit": 5, "searchTerm": pattern});
            List<Follower> followers = (result as List<dynamic>)
                .map((data) => Follower.fromJson(data))
                .toList();

            return followers;
          },
          itemBuilder: (context, suggestion) {
            final follower = suggestion as Follower;
            return ListTile(
              title: Text(follower.name),
              subtitle: Text(follower.phoneNumber.toString()),
            );
          },
          onSuggestionSelected: (suggestion) {
            final follower = suggestion as Follower;

            _typeAheadController.text = follower.name;
            _selectedUser = follower.id;
            setState(() {
              _showPhoneField = false;
            });

            widget.onUserSelected(_selectedUser);
          },
          noItemsFoundBuilder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _showPhoneField = true;
              });
            });
            return SizedBox.shrink();
          },
        ),
        if (_showPhoneField) ...[
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          PhoneNumberField(
            onSaved: widget.onPhoneChanged,
            onError: (String error) => widget.onPhoneChanged(null),
            withIcon: widget.withIcon,
          )
        ],
      ],
    );
  }
}
