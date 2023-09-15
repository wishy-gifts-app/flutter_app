import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:shop_app/constants.dart';

class OrderStatusStepper extends StatelessWidget {
  final bool isOrderCompleted;
  final bool isInDelivery;
  final bool isOrderApproved;

  OrderStatusStepper({
    required this.isOrderCompleted,
    required this.isInDelivery,
    required this.isOrderApproved,
  });

  int get activeStep {
    if (isOrderCompleted) return 2;
    if (isInDelivery) return 1;
    if (isOrderApproved) return 0;
    return -1; // No step is active
  }

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: activeStep,
      lineLength: 70,
      lineSpace: 1,
      lineType: LineType.normal,
      defaultLineColor: kPrimaryLightColor,
      finishedLineColor: kPrimaryColor,
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      finishedStepBackgroundColor: kPrimaryColor,
      activeStepIconColor: kPrimaryColor,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 20,
      showStepBorder: false,
      steps: [
        EasyStep(
          finishIcon: Icon(Icons.check),
          icon: Icon(Icons.approval),
          title: 'Approved',
        ),
        EasyStep(
          finishIcon: Icon(Icons.check),
          icon: Icon(Icons.delivery_dining),
          title: 'In Delivery',
        ),
        EasyStep(
          icon: Icon(Icons.shopping_bag),
          title: 'Received',
        ),
      ],
    );
  }
}
