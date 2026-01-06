import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';

class AIChatService {
  static String url = "https://api.mistral.ai/v1/";
  static String? apiKey = dotenv.env["MISTRAL_API_KEY"];

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: url,
      headers: {
        // 'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${apiKey ?? ""}'
      },
    ),
  );

  static Future<QuestionCreateModel> askAIRecommendation(
    String title,
    String description,
    String? category,
    String existingQuestions
  ) async {
    final response = await _dio.post(
      "${url}chat/completions",
      data: {
        "messages": [
          {
            "role": "user",
            "content":
                "You are a quiz generator. Return only valid minified JSON.\n\n"
                "DO NOT duplicate existing questions"
                "DO NOT include commentary or any markdown formatting, and do not start with \"```json\" and do not end \"```\".\n\n"
                "Generate ONE quiz question with this exact structure:\n\n"
                "{\n"
                "  text: \"<question text>\",\n"
                "  imageUrl: null,\n"
                "  answers: [\n"
                "    {\n"
                "       text: \"<question text>\",\n"
                "       isTrueAnswer: \"true/false\"\n"
                "    }\n"
                "  ]\n"
                "}\n\n"
                "Rules:\n"
                "- Always provide exactly 4 answers.\n"
                "- Exactly ONE answer must have isTrueAnswer: true.\n"
                "- Make sure the JSON is valid and parseable.\n"
                "- Language: Indonesian.\n"
                "- Title: $title.\n"
                "- Description: $description.\n"
                "- Category: $category.\n"
                "- Existing Questions: $existingQuestions.\n"
          }
        ],
        "model": "mistral-large-latest"
      },
    );

    // the response is string
    // decode to json first
    // then parse
    final jsonResponse = jsonDecode(response.data["choices"][0]["message"]["content"]);
    final QuestionCreateModel result = QuestionCreateModel.fromJson(jsonResponse);

    return result;
  }
}