import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Wishy/screens/success/components/login.dart' as LoginComponent;
import 'package:Wishy/screens/success/components/purchase.dart'
    as PurchaseComponent;

enum SuccessTypes { login, purchase }

class Body extends StatefulWidget {
  final SuccessTypes type;

  const Body({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _isCurrentPageActive = true;

  void _onPress(String routeName) {
    if (_isCurrentPageActive) {
      _isCurrentPageActive = false;
      Navigator.pushReplacementNamed(context, routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.type == SuccessTypes.login) {
      Future.delayed(Duration(seconds: LoginComponent.Login.SCREEN_TIME), () {
        _onPress(LoginComponent.Login.CTA_ROUTE_NAME);
      });
    } else if (widget.type == SuccessTypes.purchase) {
      Future.delayed(Duration(seconds: PurchaseComponent.Purchase.SCREEN_TIME),
          () {
        _onPress(PurchaseComponent.Purchase.CTA_ROUTE_NAME);
      });
    }
  }

  Widget _buildSuccessScreen() {
    switch (widget.type) {
      case SuccessTypes.login:
        return LoginComponent.Login(onPressHandler: _onPress);
      case SuccessTypes.purchase:
        return PurchaseComponent.Purchase(onPressHandler: _onPress);
      default:
        return Center(child: Text('Unknown success type'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuccessScreen();
  }
}
