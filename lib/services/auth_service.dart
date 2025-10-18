import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';

class AuthService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}auth/";

  static Future<BaseResponse<TokenModel>> login(String email, String password) async {
    final baseUri = Uri.parse('${url}login');
    final body = jsonEncode({"email": email, "password": password});

    final response = await http.post(
      baseUri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: body
    );

    final responseJson = jsonDecode(response.body);
    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => TokenModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<UserModel>> checkAuth(String token) async {
    final response = await http.get(
      Uri.parse('${url}check-auth'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 401) {
      throw ApiException("Unauthorized");
    }

    final responseJson = jsonDecode(response.body);
    final BaseResponse<UserModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => UserModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<TokenModel>> register(String email, String name, String username, String password) async {
    final baseUri = Uri.parse('${url}register');
    final body = jsonEncode({
      "email": email,
      "name": name,
      "username": username,
      "password": password
    });

    final response = await http.post(
      baseUri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: body
    );

    final responseJson = jsonDecode(response.body);
    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => TokenModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
  
  static Future<BaseResponse<TokenModel>> checkOtp(String email, String otpCode) async {
    final baseUri = Uri.parse('${url}otp');
    final body = jsonEncode({
      "email": email,
      "otpCode": otpCode,
    });

    final response = await http.post(
      baseUri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: body
    );

    final responseJson = jsonDecode(response.body);
    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => TokenModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<TokenModel>> loginWithGoogle(String idToken) async {
    final baseUri = Uri.parse('${url}login-with-google');
    final body = jsonEncode({"idToken": idToken});

    final response = await http.post(
      baseUri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: body
    );

    final responseJson = jsonDecode(response.body);
    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => TokenModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}