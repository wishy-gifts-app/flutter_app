import 'package:Wishy/components/phone_number_field.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchUserWidget extends StatefulWidget {
  final Function(int? userId, bool? isActiveUser) onUserSelected;
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
  bool _isActiveUser = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        TypeAheadFormField(
          hideSuggestionsOnKeyboardHide: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          direction: AxisDirection.up,
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
              constraints: BoxConstraints(maxHeight: 150)),
          onSaved: (newValue) => {
            if (_showPhoneField)
              widget.onNameChanged(newValue)
            else
              widget.onUserSelected(_selectedUser, _isActiveUser)
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
            decoration: InputDecoration(
                labelStyle: TextStyle(backgroundColor: Colors.white),
                labelText: 'Search User',
                filled: true,
                fillColor: Colors.white),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.length < 1) {
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
          onSuggestionSelected: (suggestion) async {
            final follower = suggestion as Follower;

            _typeAheadController.text = follower.name;
            _selectedUser = follower.id;

            setState(() {
              _showPhoneField = false;
            });

            final result = await graphQLQueryHandler(
                "isPhoneExists", {"id": follower.id, "is_active_user": true});

            setState(() {
              _isActiveUser = result["result"];
            });

            widget.onUserSelected(_selectedUser, _isActiveUser);
            widget.onNameChanged(follower.name);
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
