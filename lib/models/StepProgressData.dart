import 'package:Wishy/models/utils.dart';
import 'package:Wishy/screens/home/components/custom_progress_bar.dart';

StepTypes getStepTypeFromString(String typeStr) {
  switch (typeStr) {
    case 'connect':
      return StepTypes.connect;
    case 'discount':
      return StepTypes.discount;
    case 'recommendation':
      return StepTypes.recommendation;
    case 'line':
      return StepTypes.line;
    default:
      return StepTypes.newVersion;
  }
}

class StepProgressData {
  final int id;
  final StepTypes type;
  final String? tooltipText;
  final int stepNumber;
  final bool isActive;

  StepProgressData({
    required this.id,
    required this.type,
    this.isActive = false,
    this.tooltipText = null,
    required this.stepNumber,
  });

  factory StepProgressData.fromJson(Map<String, dynamic> json) {
    return StepProgressData(
      type: getStepTypeFromString(json['type']),
      id: convertValue<int>(json, 'id', true),
      stepNumber: convertValue<int>(json, 'step_number', true),
      tooltipText: convertValue<String?>(json, 'tooltip_text', false),
      isActive:
          convertValue<bool>(json, 'is_active', false, defaultValue: false),
    );
  }
}
