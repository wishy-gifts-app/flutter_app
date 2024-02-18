import 'package:Wishy/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:Wishy/constants.dart';

class OrderStatusStepper extends StatelessWidget {
  final Order order;

  OrderStatusStepper({
    required this.order,
  });

  int get activeStep {
    if (order.arrivedAt != null) return 3;
    if (order.deliveredAt != null) return 2;
    if (order.approvedAt != null) return 1;
    if (order.paidAt != null) return 0;
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
      unreachedStepIconColor: kPrimaryLightColor,
      finishedLineColor: kPrimaryColor,
      activeStepTextColor: kPrimaryColor,
      finishedStepTextColor: kPrimaryColor,
      finishedStepBackgroundColor: kPrimaryColor,
      activeStepIconColor: kPrimaryColor,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 15,
      showStepBorder: false,
      steps: [
        EasyStep(
            customStep: _generateCustomStep(Icons.approval,
                order.approvedAt != null, order.approvedAt != null),
            customTitle: _generateCustomStepTitle(order.approveStage!.title,
                order.approveStage!.subtitle, order.approvedAt != null)),
        EasyStep(
            customStep: _generateCustomStep(Icons.delivery_dining,
                order.deliveredAt != null, order.deliveredAt != null),
            customTitle: _generateCustomStepTitle(order.deliverStage!.title,
                order.deliverStage!.subtitle, order.deliveredAt != null)),
        EasyStep(
            customStep: _generateCustomStep(Icons.shopping_bag,
                order.arrivedAt != null, order.arrivedAt != null),
            customTitle: _generateCustomStepTitle(order.receiveStage!.title,
                order.receiveStage!.subtitle, order.arrivedAt != null)),
      ],
    );
  }

  Widget _generateCustomStepTitle(
      String title, String subtitle, bool isActive) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? kPrimaryColor : kPrimaryLightColor,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            height: 1.3,
            color: isActive ? kPrimaryColor : kPrimaryLightColor,
          ),
        )
      ],
    );
  }

  Widget _generateCustomStep(
      IconData iconData, bool isActive, bool isCompleted) {
    return isCompleted
        ? Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          )
        : CircleAvatar(
            backgroundColor: isActive ? kPrimaryColor : Colors.white,
            child: Icon(
              iconData,
              color: isActive ? Colors.white : kPrimaryLightColor,
              size: 18,
            ));
  }
}
