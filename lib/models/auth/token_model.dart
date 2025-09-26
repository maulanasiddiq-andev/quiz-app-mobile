class TokenModel {
  final String token;
  final String refreshToken;
  final DateTime refreshTokenExpiredTime;
  final bool isValidLogin;

  TokenModel({
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiredTime,
    required this.isValidLogin
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    token: json['token'], 
    refreshToken: json['refreshToken'], 
    refreshTokenExpiredTime: DateTime.parse(json['refreshTokenExpiredTime']), 
    isValidLogin: json['isValidLogin']
  );
}