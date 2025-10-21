import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class CategoryService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}category/";

  static Future<BaseResponse<SearchResponse<CategoryModel>>> getCategories(
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
    final BaseResponse<SearchResponse<CategoryModel>> result =
        BaseResponse.fromJson(
          responseJson,
          fromJsonT: (data) => SearchResponse.fromJson(
            data,
            (item) => CategoryModel.fromJson(item),
          ),
        );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<CategoryModel>> addCategory(String name, String description) async {
    final uri = Uri.parse(url);
    var token = await storage.read(key: 'token');
    final body = {
      "name": name,
      "description": description
    };

    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(body)
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<CategoryModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (item) => CategoryModel.fromJson(item),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}
