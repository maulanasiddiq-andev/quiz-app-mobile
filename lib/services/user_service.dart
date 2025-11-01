import 'dart:convert';

import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class UserService {
  static ClientSettings client = ClientSettings();
  static String url = "user/";

  static Future<BaseResponse<SearchResponse<UserModel>>> getUsers(Map<String, dynamic> queryParameters) async {
    final response = await client.dio.get(
      url,
      queryParameters: queryParameters,
    );

    final BaseResponse<SearchResponse<UserModel>> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SearchResponse.fromJson(
        data,
        (item) => UserModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<UserModel>> getUserById(String id) async {
    final response = await client.dio.get(
      '$url$id'
    );

    final BaseResponse<UserModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => UserModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<UserModel>> updateUserById(String id, Map<String, dynamic>? data) async {
    final response = await client.dio.put(
      '$url$id',
      data: jsonEncode(data)
    );

    final BaseResponse<UserModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => UserModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}
