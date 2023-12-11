import 'package:Wishy/components/interactive_dialog/multiple_options_selector.dart';
import 'package:Wishy/components/interactive_dialog/number_slide.dart';
import 'package:Wishy/components/interactive_dialog/rating_input.dart';
import 'package:Wishy/components/interactive_dialog/search_user_input.dart';
import 'package:Wishy/components/interactive_dialog/single_option_selector.dart';
import 'package:Wishy/constants.dart';
import 'package:flutter/material.dart';

enum CustomActionType {
  none,
  rate,
  numberSlider,
  multipleOptions,
  singleOption,
  searchUser,
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isConsultant;
  final CustomActionType actionType;
  final Map<String, dynamic> additionalData;
  final Function(dynamic) onSubmit;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.onSubmit,
    this.additionalData = const {},
    this.isConsultant = false,
    this.actionType = CustomActionType.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isConsultant ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isConsultant) ProfileIcon(),
        MessageBubble(
            message: message,
            isConsultant: isConsultant,
            actionType: actionType,
            onSubmit: onSubmit,
            additionalData: additionalData),
      ],
    );
  }
}

class ProfileIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/consultant_profile.png'),
        radius: 20,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isConsultant;
  final CustomActionType actionType;
  final Function(dynamic) onSubmit;
  final Map<String, dynamic> additionalData;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.additionalData,
    this.isConsultant = false,
    this.actionType = CustomActionType.none,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: isConsultant ? Colors.grey[200] : kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isConsultant ? Colors.black : Colors.white),
          ),
          if (actionType != CustomActionType.none) ...[
            SizedBox(height: 8),
            getCustomActionWidget(actionType, additionalData),
          ],
        ],
      ),
    );
  }

  Widget getCustomActionWidget(
      CustomActionType actionType, Map<String, dynamic> data) {
    Widget actionWidget;

    switch (actionType) {
      case CustomActionType.rate:
        actionWidget = RatingInput(
          onSelect: onSubmit,
        );
        break;
      case CustomActionType.numberSlider:
        actionWidget = NumberSlider(
            onSelect: onSubmit,
            max: data["max"],
            min: data["min"],
            divisions: data["divisions"]);
        break;
      case CustomActionType.multipleOptions:
        actionWidget = MultipleOptionsSelector(
          onSelect: onSubmit,
          options: data["options"],
        );
        break;
      case CustomActionType.singleOption:
        actionWidget = SingleOptionSelector(
          onSelect: onSubmit,
          options: data["options"],
        );
        break;
      case CustomActionType.searchUser:
        actionWidget = SearchUserInput(
          onSelect: onSubmit,
          cta: data["cta"],
        );
        break;
      default:
        actionWidget = SizedBox.shrink();
        break;
    }

    return actionWidget;
  }
}
