import 'package:Wishy/components/search_user.dart';
import 'package:Wishy/screens/checkout/components/payment_button.dart';
import 'package:Wishy/services/graphql_service.dart';
import 'package:Wishy/size_config.dart';
import 'package:flutter/material.dart';

class BuyAsGift extends StatelessWidget {
  final int variantId;
  final double price;

  BuyAsGift({
    required this.variantId,
    required this.price,
  });

  int? userId;
  String? name, phoneNumber;
  void _onUserSelected(int? userId, bool? isActiveUser) {
    userId = userId;
  }

  void _onNameChanged(String? name) {
    name = name;
  }

  void _onPhoneChanged(String? phone) {
    phone = phone;
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      final result = await graphQLQueryHandler("checkoutHandler", {
        "variant_id": variantId,
        "user_id": userId,
        "phone_number": phoneNumber,
        "name": name,
        "quantity": 1,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Unable to upload payment method. Please check your information and try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchUserWidget(
          onUserSelected: _onUserSelected,
          onNameChanged: _onNameChanged,
          onPhoneChanged: _onPhoneChanged,
        ),
        SizedBox(height: getProportionateScreenHeight(90)),
        PaymentButton(
          price: price,
          onSubmit: () => onSubmit(
            context,
          ),
          enable: userId != null || (phoneNumber != null && name != null),
        ),
      ],
    );
  }
}
