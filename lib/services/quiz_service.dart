import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/search_responses.dart';

class QuizService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}quiz/";

  static Future<BaseResponse<SearchResponse<QuizModel>>> getQuizzes(
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
    final BaseResponse<SearchResponse<QuizModel>> result = BaseResponse.fromJson(
      responseJson,
      (data) => SearchResponse.fromJson(
        data,
        (item) => QuizModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> getQuizById(String id) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$url$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      responseJson,
      (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> takeQuiz(String quizId, QuizExamModel quizExam) async {
    final token = await storage.read(key: 'token');
    final baseUri = Uri.parse('$url$quizId/take-quiz');
    final body = jsonEncode(quizExam.toJson());

    final response = await http.post(
      baseUri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: body
    );

    final responseJson = jsonDecode(response.body);
    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      responseJson,
      (data) => QuizModel.fromJson(data)
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<SearchResponse<QuizHistoryModel>>> getHistoriesByQuizId(
    String quizId,
    int page,
    int pageSize
  ) async {
    final baseUri = Uri.parse('$url$quizId/history');
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
    final BaseResponse<SearchResponse<QuizHistoryModel>> result = BaseResponse.fromJson(
      responseJson,
      (data) => SearchResponse.fromJson(
        data,
        (item) => QuizHistoryModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}