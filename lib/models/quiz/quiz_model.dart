import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';

class QuizModel {
  final String quizId;
  final String? userId;
  final UserModel? user;
  final String? categoryId;
  final CategoryModel? category;
  final String title;
  String? imageUrl;
  final int time;
  final int? historiesCount;
  final int questionCount;
  final List<QuestionModel> questions;
  final String? description;
  final int version;

  QuizModel({
    required this.quizId,
    required this.userId,
    required this.user,
    required this.categoryId,
    required this.category,
    required this.title,
    this.imageUrl,
    required this.time,
    required this.historiesCount,
    required this.questionCount,
    this.questions = const [],
    this.description,
    required this.version
  });

  QuizModel.fromJson(Map<String, dynamic> json)
    : quizId = json['quizId'],
      userId = json['userId'],
      user = json['user'] != null ? UserModel.fromJson(json['user']) : null,
      categoryId = json['categoryId'],
      category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
      title = json['title'],
      imageUrl = json['imageUrl'],
      time = json['time'],
      questions = (json['questions'] as List)
          .map((data) => QuestionModel.fromJson(data))
          .toList(),
      historiesCount = json['historiesCount'],
      questionCount = json['questionCount'],
      description = json['description'],
      version = json['version'];
}
