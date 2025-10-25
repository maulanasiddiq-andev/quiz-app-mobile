import 'dart:convert';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';

class AuthService {
  static ClientSettings client = ClientSettings();
  static String url = "auth/";

  static Future<BaseResponse<TokenModel>> login(
    String email,
    String password,
  ) async {
    final body = jsonEncode({"email": email, "password": password});
    final response = await client.dio.post(
      '${url}login',
      data: body
    );

    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => TokenModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<SimpleUserModel>> checkAuth(String token) async {
    final response = await client.dio.get(
      '${url}check-auth',
    );
    if (response.statusCode == 401) {
      throw ApiException("Unauthorized");
    }

    final BaseResponse<SimpleUserModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SimpleUserModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<TokenModel>> register(
    String email,
    String name,
    String username,
    String password,
  ) async {
    final body = jsonEncode({
      "email": email,
      "name": name,
      "username": username,
      "password": password,
    });

    final response = await client.dio.post(
      '${url}register',
      data: body
    );

    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => TokenModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<TokenModel>> checkOtp(
    String email,
    String otpCode,
  ) async {
    final body = jsonEncode({"email": email, "otpCode": otpCode});
    final response = await client.dio.post(
      '${url}otp',
      data: body
    );

    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => TokenModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<TokenModel>> loginWithGoogle(
    String idToken,
  ) async {
    final body = jsonEncode({"idToken": idToken});
    final response = await client.dio.post(
      '${url}login-with-google',
      data: body
    );

    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => TokenModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}
