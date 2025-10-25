import 'dart:convert';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class CategoryService {
  static ClientSettings client = ClientSettings();
  static String url = "category/";

  static Future<BaseResponse<SearchResponse<CategoryModel>>> getCategories(
    int page,
    int pageSize,
  ) async {
    final response = await client.dio.get(
      url,
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final BaseResponse<SearchResponse<CategoryModel>> result =
        BaseResponse.fromJson(
          response.data,
          fromJsonT: (data) => SearchResponse.fromJson(
            data,
            (item) => CategoryModel.fromJson(item),
          ),
        );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<CategoryModel>> getCategoryById(String id) async {
    final response = await client.dio.get(
      '$url$id',
    );

    final BaseResponse<CategoryModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => CategoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<CategoryModel>> addCategory(String name, String description) async {
    final body = {
      "name": name,
      "description": description
    };

    final response = await client.dio.post(
      url,
      data: jsonEncode(body)
    );

    final BaseResponse<CategoryModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (item) => CategoryModel.fromJson(item),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<CategoryModel>> editCategoryById(
    String id,
    String name,
    String description,
    int version
  ) async {
    final body = jsonEncode({"name": name, "description": description, "version": version});
    final response = await client.dio.put(
      '$url$id',
      data: body
    );

    final BaseResponse<CategoryModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => CategoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}
