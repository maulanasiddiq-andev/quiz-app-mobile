import 'dart:convert';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/interceptor/client_settings.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class QuizService {
  static ClientSettings client = ClientSettings();
  static String url = "quiz/";

  static Future<BaseResponse<SearchResponse<QuizModel>>> getQuizzes(
    int page,
    int pageSize,
    String categoryId
  ) async {
    final response = await client.dio.get(
      url,
      queryParameters: {
        "pageSize": pageSize.toString(),
        "currentPage": page.toString(),
        "categoryId": categoryId
      }
    );

    final BaseResponse<SearchResponse<QuizModel>> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SearchResponse.fromJson(
        data,
        (item) => QuizModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> getQuizById(String id) async {
    final response = await client.dio.get('$url$id');

    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> getQuizByIdWithQuestions(String id) async {
    final response = await client.dio.get('$url$id/take-quiz');

    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
  
  static Future<BaseResponse<QuizHistoryModel>> checkQuiz(String id, Map<String, dynamic> quiz) async {
    final response = await client.dio.post(
      '$url$id/check-quiz',
      data: jsonEncode(quiz)
    );

    final BaseResponse<QuizHistoryModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => QuizHistoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> createQuiz(Map<String, dynamic> quiz) async {
    final response = await client.dio.post(
      url,
      data: jsonEncode(quiz)
    );

    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<SearchResponse<QuizHistoryModel>>> getHistoriesByQuizId(
    String quizId,
    int page,
    int pageSize
  ) async {
    final response = await client.dio.get(
      '$url$quizId/history',
      queryParameters: {
        'currentPage': page.toString(),
        'pageSize': pageSize.toString(),
      }
    );

    final BaseResponse<SearchResponse<QuizHistoryModel>> result = BaseResponse.fromJson(
      response.data,
      fromJsonT: (data) => SearchResponse.fromJson(
        data,
        (item) => QuizHistoryModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}