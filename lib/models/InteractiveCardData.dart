import 'package:Wishy/components/interactive_card/interactive_card.dart';
import 'package:Wishy/models/utils.dart';

CardTypes getCardTypeFromString(String typeStr) {
  switch (typeStr) {
    case 'question':
      return CardTypes.question;
    case 'invite':
      return CardTypes.invite;
    case 'message':
      return CardTypes.message;
    default:
      return CardTypes.newVersion;
  }
}

class InteractiveCardData extends Identifiable {
  final int id;
  final CardTypes type;
  final String question, backgroundImagePath;
  final int? productsCountTrigger;
  final Map<String, dynamic> additionalData;
  final Map<String, dynamic> customData;
  final int? customTriggerId;

  InteractiveCardData(
      {required this.id,
      required this.type,
      required this.question,
      required this.backgroundImagePath,
      this.additionalData = const {},
      this.customData = const {},
      this.customTriggerId = null,
      this.productsCountTrigger});

  factory InteractiveCardData.fromJson(Map<String, dynamic> json) {
    return InteractiveCardData(
      type: getCardTypeFromString(json['type']),
      id: convertValue<int>(json, 'id', true),
      productsCountTrigger:
          convertValue<int?>(json, 'products_count_trigger', false),
      question: convertValue<String>(json, 'question', true),
      backgroundImagePath:
          convertValue<String>(json, 'background_image_path', true),
      customTriggerId: convertValue<int?>(json, 'custom_trigger_id', false),
      additionalData: json["additional_data"],
      customData: json["custom_data"] == null || json["custom_data"]
          ? {}
          : json["custom_data"],
    );
  }
}
