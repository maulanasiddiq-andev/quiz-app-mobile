import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/identity/role_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class RoleService {
  static ClientSettings client = ClientSettings();
  static String url = "role/";

  static Future<BaseResponse<SearchResponse<RoleModel>>> getRoles(
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

    final BaseResponse<SearchResponse<RoleModel>> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SearchResponse.fromJson(data, (item) => RoleModel.fromJson(item)),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<RoleModel>> getRoleById(String id) async {
    final response = await client.dio.get(
      '$url$id'
    );

    final BaseResponse<RoleModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => RoleModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}