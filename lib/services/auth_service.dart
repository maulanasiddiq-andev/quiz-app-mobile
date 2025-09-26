import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/base_response.dart';

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
    print(responseJson);
    final BaseResponse<TokenModel> result = BaseResponse.fromJson(
      responseJson,
      (data) => TokenModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}