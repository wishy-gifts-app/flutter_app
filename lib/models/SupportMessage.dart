import 'package:Wishy/models/utils.dart';

class SupportMessage {
  final int id;
  final int user_id;
  final String? message;
  final bool? isConsultant;
  final bool? isEndChat;
  final DateTime? readAt;

  SupportMessage(
      {required this.id,
      required this.user_id,
      this.isConsultant,
      this.readAt,
      this.isEndChat,
      this.message});

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: convertValue<int>(json, 'id', true),
      user_id: convertValue<int>(json, 'user_id', true),
      isConsultant: convertValue<bool?>(json, 'is_consultant', false),
      isEndChat: convertValue<bool?>(json, 'is_end_chat', false),
      readAt: convertValue<DateTime?>(json, 'read_at', false),
      message: convertValue<String?>(json, 'message', false),
    );
  }
}
