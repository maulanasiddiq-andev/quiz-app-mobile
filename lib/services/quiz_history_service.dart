import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quiz_app/constants/environment_contant.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';

class QuizHistoryService {
  static const storage = FlutterSecureStorage();
  static String url = "${EnvironmentConstant.url}history/";

  static Future<BaseResponse<QuizHistoryModel>> getQuizHistoryById(String id) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$url$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final dynamic responseJson = jsonDecode(response.body);
    final BaseResponse<QuizHistoryModel> result = BaseResponse.fromJson(
      responseJson,
      (data) => QuizHistoryModel.fromJson(data),
    );

    if (result.succeed == false) throw ApiException(result.messages[0]);

    return result;
  } 
}