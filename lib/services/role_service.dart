import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/role_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class RoleService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}role/";

  static Future<BaseResponse<SearchResponse<RoleModel>>> getRoles(
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
    final BaseResponse<SearchResponse<RoleModel>> result =
        BaseResponse.fromJson(
          responseJson,
          fromJsonT: (data) =>
              SearchResponse.fromJson(data, (item) => RoleModel.fromJson(item)),
        );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<RoleModel>> getRoleById(String id) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$url$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<RoleModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => RoleModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}