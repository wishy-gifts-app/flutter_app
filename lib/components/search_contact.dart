import 'package:Wishy/components/phone_number_field.dart';
import 'package:Wishy/constants.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchContactWidget extends StatefulWidget {
  final Function(int? userId, bool? isActiveUser)? onUserSelected;
  final Function(String?) onNameChanged;
  final Function(String?) onPhoneChanged;
  final Follower? defaultUser;
  final bool withIcon;
  final bool nameRequired;
  final String nameHint;
  final List<String> phoneHintOptions;

  SearchContactWidget({
    this.onUserSelected = null,
    required this.onNameChanged,
    required this.onPhoneChanged,
    this.defaultUser,
    this.withIcon = true,
    this.nameRequired = false,
    this.nameHint = "Search in contacts...",
    this.phoneHintOptions = const [
      "Add manually instead",
      "E.g. +1 212-555-1234"
    ],
  });

  @override
  _SearchContactWidgetState createState() => _SearchContactWidgetState();
}

class _SearchContactWidgetState extends State<SearchContactWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _nameUpdatedByUser = false;
  int? _selectedUserId;
  bool _isActiveUser = false;

  void _onPhoneChange(String? number) {
    if (number != null)
      _afterPhoneAdded();
    else if (_selectedUserId != null) {
      widget.onNameChanged(null);
      widget.onPhoneChanged(null);

      if (_nameUpdatedByUser) _nameController.text = "";

      if (widget.onUserSelected != null) {
        widget.onUserSelected!(null, null);

        if (mounted)
          setState(() {
            _selectedUserId = null;
          });
      }
    } else {
      widget.onPhoneChanged(null);
    }
  }

  void _afterPhoneAdded() async {
    if (widget.onUserSelected != null) {
      final result = await graphQLQueryHandler(
          "isPhoneExists", {"phone_number": _phoneController.text});

      if (mounted) {
        setState(() {
          _isActiveUser = result?["is_active_user"] == true;
          _selectedUserId = result?["id"];
        });
      }

      widget.onUserSelected!(_selectedUserId, _isActiveUser);

      if (result?["name"] != null && result?["name"] != "") {
        _nameController.text = result["name"];

        if (mounted)
          setState(() {
            _nameUpdatedByUser = true;
          });
      }
    }

    widget.onNameChanged(_nameController.text);
    widget.onPhoneChanged(_phoneController.text);
  }

  void _setDefaultUser() {
    if (widget.defaultUser != null) {
      if (_nameController.text != widget.defaultUser!.name) {
        _nameController.text = widget.defaultUser!.name;
      }
      if (_phoneController.text != widget.defaultUser!.phoneNumber) {
        _phoneController.text = widget.defaultUser!.phoneNumber;
      }
    }
  }

  @override
  void initState() {
    _setDefaultUser();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchContactWidget oldWidget) {
    if (widget.defaultUser != oldWidget.defaultUser) {
      Future.delayed(Duration.zero, _setDefaultUser);
    }

    super.didUpdateWidget(oldWidget);
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
      validator: (v) {
        if (widget.nameRequired && (v == null || v == "")) {
          return kUserNameNullError;
        }
        return null;
      },
      hideOnEmpty: true,
      hideSuggestionsOnKeyboardHide: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      direction: AxisDirection.up,
      onSaved: (_) => {widget.onNameChanged(_nameController.text)},
      textFieldConfiguration: TextFieldConfiguration(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: widget.nameHint,
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

        _afterPhoneAdded();
      },
    );
  }

  Widget _buildPhoneInput() {
    return PhoneNumberField(
      controller: _phoneController,
      hintOptions: widget.phoneHintOptions,
      onSaved: _onPhoneChange,
      onError: (String error) => _onPhoneChange(null),
      withIcon: widget.withIcon,
    );
  }
}
