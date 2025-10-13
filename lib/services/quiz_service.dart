import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/utils/convert_media_type.dart';

class QuizService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}quiz/";

  static Future<BaseResponse<SearchResponse<QuizModel>>> getQuizzes(
    int page,
    int pageSize,
    String categoryId
  ) async {
    final baseUri = Uri.parse(url);
    final uri = baseUri.replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'categoryId': categoryId
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
      fromJsonT: (data) => SearchResponse.fromJson(
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
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> getQuizByIdWithQuestions(String id) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$url$id/take-quiz'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
  
  static Future<BaseResponse<QuizHistoryModel>> checkQuiz(String id, Map<String, dynamic> quiz) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$url$id/check-quiz'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(quiz)
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<QuizHistoryModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => QuizHistoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<BaseResponse<QuizModel>> createQuiz(Map<String, dynamic> quiz) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', 
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(quiz)
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<QuizModel> result = BaseResponse.fromJson(
      responseJson,
      fromJsonT: (data) => QuizModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }

  static Future<String> uploadQuizImage(String directory, File image) async {
    var token = await storage.read(key: 'token');
    final uri = Uri.parse('${url}upload-image');

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields.addAll({
      'directory': directory,
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: convertPathToMediaType(image.path),
      ),
    );

    final streamedBody = await request.send();
    final response = await streamedBody.stream.bytesToString();
    final responseJson = jsonDecode(response);

    var result = BaseResponse<String>.fromJson(responseJson);

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result.data!;
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
      fromJsonT: (data) => SearchResponse.fromJson(
        data,
        (item) => QuizHistoryModel.fromJson(item),
      ),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  }
}