import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class UserService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}user/";

  static Future<BaseResponse<SearchResponse<UserModel>>> getCategories(
    int page,
    int pageSize,
  ) async {
    final baseUri = Uri.parse(url);
    final uri = baseUri.replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    var token = await storage.read(key: 'token');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<SearchResponse<UserModel>> result =
        BaseResponse.fromJson(
          responseJson,
          fromJsonT: (data) => SearchResponse.fromJson(
            data,
            (item) => UserModel.fromJson(item),
          ),
        );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}