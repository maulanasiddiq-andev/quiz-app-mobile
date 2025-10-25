import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class UserService {
  static ClientSettings client = ClientSettings();
  static String url = "user/";

  static Future<BaseResponse<SearchResponse<SimpleUserModel>>> getUsers(
    int page,
    int pageSize,
  ) async {
    // final baseUri = Uri.parse(url);
    // final uri = baseUri.replace(
      // queryParameters: {
      //   'page': page.toString(),
      //   'pageSize': pageSize.toString(),
      // },
    // );

    // var token = await storage.read(key: 'token');
    // final response = await http.get(
    //   uri,
    //   headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    // );
    final response = await client.dio.get(
      url,
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final BaseResponse<SearchResponse<SimpleUserModel>> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SearchResponse.fromJson(
        data,
        (item) => SimpleUserModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<SimpleUserModel>> getUserById(String id) async {
    final response = await client.dio.get(
      '$url$id'
    );

    final BaseResponse<SimpleUserModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SimpleUserModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}
