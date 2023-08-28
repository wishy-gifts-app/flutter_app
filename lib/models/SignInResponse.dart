import 'utils.dart';

class SignInResponse {
  final String token;
  final bool profileCompleted;
  final int userId;

  SignInResponse(
      {required this.token,
      required this.profileCompleted,
      required this.userId});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      token: convertValue<String>(json, 'auth', true),
      profileCompleted: convertValue<bool>(json, 'profile_completed', true),
      userId: convertValue<int>(json, 'user_id', true),
    );
  }
}
