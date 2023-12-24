import 'dart:async';
import 'package:Wishy/components/default_button.dart';
import 'package:Wishy/components/search_contact.dart';
import 'package:Wishy/global_manager.dart';
import 'package:Wishy/models/Follower.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:Wishy/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:rounded_background_text/rounded_background_text.dart';

class InviteCard extends StatefulWidget {
  final Function(Map<String, dynamic>, String) onSelect;
  final String CTA;
  final String question;
  final String? connectUser;
  final Follower? suggestUser;

  InviteCard({
    Key? key,
    required this.onSelect,
    required this.CTA,
    required this.question,
    this.connectUser,
    this.suggestUser,
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
  bool _giveNotificationPermission = true;
  bool _loading = false;
  bool _press = false;

  void _handleNameChanged(String? name) {
    setState(() => _name = name);
  }

  void _handlePhoneChanged(String? phone) {
    setState(() => _phone = phone);
    _phoneValidationCompleter!.complete(true);

    if (!_press) _handleSendInvitation();
  }

  void _handleUserSelected(int? userId, bool? isActiveUser) {
    setState(() {
      _userId = userId;
      _isActiveUser = isActiveUser;
    });
  }

  void _handleSendInvitation() async {
    _press = true;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_userId == null) {
        _phoneValidationCompleter = Completer<bool>();
        await _phoneValidationCompleter!.future;
      }

      if (_userId != null || _phone != null) {
        setState(() {
          _loading = true;
        });

        if (_giveNotificationPermission &&
            GlobalManager().notificationAvailable == null) {
          Map<String, dynamic> notificationData =
              await requestNotificationPermission();

          graphQLQueryHandler("updateUserById", {
            "id": GlobalManager().userId,
            "notification_available": notificationData["available"],
            "fcm_token": notificationData["fcmToken"],
          }).then((v) => GlobalManager().setParams(
              newNotificationAvailable: notificationData["available"]));
        }

        widget.onSelect(
            {"name": _name, "user_id": _userId, "phone_number": _phone},
            this._isActiveUser == true
                ? "Fetching ${_name}'s Favorite Picks..."
                : "Inviting ${_name} to Share...");
      }
    }

    _press = false;
  }

  void _handleDisconnect() async {
    setState(() {
      _loading = true;
    });

    widget.onSelect({"disconnect": true}, "Disconnecting...");
  }

  _initSuggestUser() {
    if (widget.suggestUser != null && mounted) {
      setState(() {
        _name = widget.suggestUser!.name;
        _phone = widget.suggestUser!.phoneNumber;
        _userId = widget.suggestUser!.id;
        _isActiveUser = true;
      });
    }
  }

  @override
  void initState() {
    _initSuggestUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.connectUser != null)
      return Column(
        children: [
          RoundedBackgroundText(
            "View ${widget.connectUser}'s Wishlist to find the perfect gift!",
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
            loading: _loading,
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
                defaultUser: widget.suggestUser,
                withIcon: false),
            SizedBox(height: getProportionateScreenHeight(20)),
            if (GlobalManager().notificationAvailable == null)
              CheckboxListTile(
                title: RoundedBackgroundText(
                  "Invitation Watch: Get quick updates on friend’s gift choices",
                  backgroundColor: Colors.white.withOpacity(0.6),
                  style: TextStyle(fontSize: 12),
                ),
                value: _giveNotificationPermission,
                onChanged: (bool? value) {
                  setState(() {
                    _giveNotificationPermission = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            SizedBox(height: getProportionateScreenHeight(5)),
            DefaultButton(
              loading: _loading,
              press: _handleSendInvitation,
              text: widget.CTA,
            ),
          ],
        ));
  }
}
