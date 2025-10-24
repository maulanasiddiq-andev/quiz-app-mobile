import 'package:quiz_app/models/identity/user_model.dart';

class TokenModel {
  final String token;
  final String refreshToken;
  final DateTime refreshTokenExpiredTime;
  final bool isValidLogin;
  final UserModel? user;

  TokenModel({
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiredTime,
    required this.isValidLogin,
    this.user
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    token: json['token'], 
    refreshToken: json['refreshToken'], 
    refreshTokenExpiredTime: DateTime.parse(json['refreshTokenExpiredTime']), 
    isValidLogin: json['isValidLogin'],
    user: UserModel.fromJson(json['user'])
  );
}