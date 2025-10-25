import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';

class QuizHistoryService {
  static ClientSettings client = ClientSettings();
  static String url = "history/";

  static Future<BaseResponse<QuizHistoryModel>> getQuizHistoryById(String id) async {
    final response = await client.dio.get(
      '$url$id'
    );

    final BaseResponse<QuizHistoryModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => QuizHistoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  } 
}